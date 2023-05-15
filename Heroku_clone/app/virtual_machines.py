from flask import (Blueprint,current_app,request,
flash,redirect,url_for,render_template)
from pathlib import Path

import os
import pulumi
import pulumi_aws as aws
import pulumi.automation as auto

bp = Blueprint("virtual_machines",__name__,url_prefix="/vms")
instance_types = ['c5.xlarge','p2.xlarge','p3.2xlarge']

def create_pulumi_program(keydata: str, instance_type=str):
    ami = aws.ec2.get_ami(most_recent=True,owners=["amazon"],
                          filters=[aws.GetAmiFilterArgs(name="name",values=["*amzn2-ami-minimal-hvm*"])])
    
    group = aws.ec2.SecurityGroup('web-secgrp', description='Enable SSH access',
                                  ingress=[aws.ec2.SecurityGroupIngressArgs(
                                            protocol='tcp',
                                            from_port=22,
                                            to_port=22,
                                            cidr_blocks=['0.0.0.0/0']
                                  )])
    public_key = keydata

    if keydata is None or public_key == "":
        home = str(Path-home())
        fileToOpen = open(os.path.join(home, '.ssh/id_rsa.pub'), 'r')
        public_key = fileToOpen.read()
        fileToOpen.close()
    
    public_key = public_key.strip()

    keypair = aws.ec2.KeyPair("dlami-keypair", public_key=public_key)

    server = aws.ec2.Instance('dlami-server', instance_type=instance_type,
                              vpc_security_group_ids=[group.id],ami=ami.id)
    
    pulumi.export('instance_type', server.instance_type)
    pulumi.export('public_key', keypair.public_key)
    pulumi.export('public_ip', server.public_ip)
    pulumi.export('public_dns', server.public_dns)


@bp.route("/new", methods=["GET","POST"])
def create_vm():
    """ Create a new Virtual Machine"""
    if request.method == "POST":
        stack_name = request.form.get("vm-id")
        keydata = request.form.get("vm-keypair")
        instance_type = request.form.get("instance_type")

        def pulumi_program():
            return create_pulumi_program(keydata, instance_type)
        
        try:
            # Create a new stack
            stack = auto.create_stack(
                    stack_name = str(stack_name),
                    project_name = current_app.config["PROJECT_NAME"],
                    program = pulumi_program
            )
            stack.set_config("aws:region", auto.ConfigValue("sa-east-1"))
            # Deploy the stack
            stack.up(on_output=print)
            flash(f"Virtual Machine '{stack_name}' was successfully created", category="success")
        except auto.StackAlreadyExistsError:
            flash(f"Error: '{stack_name}' was used, please use other name", category="danger")

        return redirect(url_for("virtual_machines.list_vms"))

@bp.route("/", methods=["GET"])
def list_vms():
    """ List all the Virtual Machines """
    vms = []
    organization_name = current_app.config["PULUMI_ORG"]
    project_name = current_app.config["PROJECT_NAME"]
    try:
        ws = auto.LocalWorkspace(project_settings=auto.ProjectSettings(
            name=project_name, runtime="python"))
        all_stacks = ws.list_stacks()
        for stack in all_stacks:
            stack = auto.select_stack(stack_name=stack.name,
                                      project_name=project_name,
                                      program=lambda: None)
            outs = stack.outputs()
            if 'public_key' in outs:
                vms.append({
                    "name": stack.name,
                    "dns_name": f"{outs['public_dns'].value}",
                    "console_url": f"https://app.pulumi.com/{organization_name}/{project_name}/{stack.name}"
                })
    except Exception as exp:
        flash(str(exp), category="danger")
    
    current_app.logger.info(f"VHS: {vms}")
    return render_template("virtual_machines/index.html", vms=vms)

@bp.route("/<string:id>/update", methods=["GET", "POST"])
def update_vm(id: str):
    """ Update a Virtual Machine """
    stack_name = id
    if request.method == "POST":
        current_app.logger.info(f"Updating VM: {stack_name}, form data: {request.form}")
        keydata = request.form.get("vm-keypair")
        current_app.logger.info(f"Updating keydata: {keydata}")
        instance_type = request.form.get("instace_type")

        def pulumi_program():
            return create_pulumi_program(keydata,instance_type)

        try:
            stack = auto.select_stack(stack_name=stack_name,
                                      project_name=current_app.config("PROJECT_NAME"),
                                      program=pulumi_program)
            stack.set_config("aws:region", auto.ConfigValue("sa-east-1"))
            # Deploy stack
            stack.up(on_output=print)
            flash(f"Virutal Machine '{stack_name}' was updated.", category="success")
        except auto.ConcurrentUpdateError:
            flash(f"Error: '{stack_name}' already has an update in progress", category="danger")
        except Exception as exp:
            flash(str(exp),category="danger")

        return redirect(url_for("virutal_machines.list_vms"))

    stack = auto.select_stack(stack_name=stack_name,
                    project_name=current_app.config("PROJECT_NAME"),
                    program=lambda: None)
    outs = stack.outputs()
    public_key = outs.get("public_key")
    if public_key:
        pk = public_key
    else:
        pk = None
    instance_type = outs.get("instance_type")
    return render_template("virtual_machines/update.html", name=stack_name, prublic_key=pk,
                            instance_types=instance_types, curr_instance_type=instance_type.value)

@bp.route("/<string:id>/delete", methods=["POST"])
def delete_vm(id: str):
    stack_name = id
    try:
        stack = auto.select_stack(stack_name=stack_name,
                project_name=current_app.config("PROJECT_NAME"),
                program=lambda: None)
        stack.destroy(on_output=print)
        stack.workspace.remove_stack(stack_name)
        flash(f"'{stack_name}' successfully deleted", category="danger")
    except auto.ConcurrentUpdateError:
        flash(f"Error: Virtual Machine '{stack_name}' already has update in progress", category="danger")
    except Exception as exp:
        flash(str(exp), category="danger")
    return redirect(url_for("virtual_machines.list_vms"))

