import json
import pulumi
import pulumi.automation as auto
import requests
from flask import (current_app,Blueprint,request,flash,redirect,url_for,render_template)
from pulumi_aws import s3

bp = Blueprint("sities", __name__, url_prefix="/sities")

def create_pulumi_program(content: str):
    # Create a bucket
    site_bucket = s3.Bucket("s3-website-bucket",
                            website=s3.BucketWebsiteArgs(index_document="index.html"))
    index_content = content

    # Wrtie the index.html into the bucket
    s3.BucketObject("index",bucket=site_bucket.id,
                    content=index_content,key="index.html",
                    content_type="text/html; charset=utf-8")

    # Set the acces policy for the bucket to read all objects
    s3.BucketPolicy("bucket-policy",bucket=site_bucket.id,
                    policy=site_bucket.id.apply(
        lambda id: json.dumps(
            {
            "Version": "2012-10-17",
            "Statement": {
                    "Effect": "Allow",
                    "Principal": "*",
                    "Action": ["s3:GetObject"],
                    # Policy refers to bucket explicitly
                    "Resource": [f"arn:aws:s3:::{id}/*"]
                },
            }
        )
    ))

    # Export the URL website
    pulumi.export("website_url", site_bucket.website_endpoint)
    pulumi.export("website_content", index_content)

@bp.route("/new", methods=["GET", "POST"])
def create_site():
    """ create a new static site """
    if request.method == "POST":
        stack_name = request.form.get("site-id")
        file_url = request.form.get("file-url")
        # If the user add a file_url
        if  file_url:
            site_content = requests.get(file_url).text
        else:
            site_content = request.form.get("site-content")

        def pulumi_program():
            return create_pulumi_program(str(site_content))

        try:
            # Create a new stack from the pulumi program function
            stack = auto.create_stack(stack_name=str(stack_name),
                    project_name=current_app.config["PROJECT_NAME"],
                    program=pulumi_program)
            stack.set_config("aws:region", auto.ConfigValue("us-east-1"))
            # Deploy the stack
            stack.up(on_output=print)
            flash(f"Site creation: Success '{stack_name}'",
                  category="success")
        except auto.StackAlreadyExistsError:
            flash(f"Error: A site with '{stack_name}' already exists. Choose other name",
                  category="danger")

        return redirect(url_for("sities.list_sities"))
    return render_template("sities/create.html")

@bp.route("/")
def list_sities():
    """ List all the sities """
    sities = []
    org_name = current_app.config["PULUMI_ORG"]
    project_name = current_app.config["PROJECT_NAME"]
    try:
        ws = auto.LocalWorkspace(
            project_settings=auto.ProjectSettings(name=project_name, runtime="python")
        )
        all_stacks = ws.list_stacks()
        for stack in all_stacks:
            stack = auto.select_stack(
                stack_name=stack.name,
                project_name=project_name,
                program=lambda: None
            )
            outs = stack.outputs()
            if 'website_url' in outs:
                sities.append({"name": stack.name,
                "url": f"http://{outs['website_url'].value}",
                "console_url": f"https://app.pulumi.com/{org_name}/{project_name}/{stack.name}"})
    except Exception as exp:
        flash(str(exp), category="danger")

    return render_template("sities/index.html", sities=sities)

@bp.route("/<string:id>/delete", methods=["POST"])
def delete_site(id: str):
    stack_name = id
    try:
        stack = auto.select_stack(
            stack_name=stack_name,
            project_name=current_app.config["PROJECT_NAME"], program=lambda: None)
        stack.destroy(on_output=print)
        stack.workspace.remove_stack(stack_name)
        flash(f"Site '{stack_name} was deleted'", category="success")
    except auto.ConcurrentUpdateError:
        flash(f"Error: Site '{stack_name}' already has update in progress", category="danger")
    except Exception as exp:
        flash(str(exp), category="danger")
    return redirect(url_for("sites.list_sites"))

@bp.route("/<string:id>/update", methods=["GET", "POST"])
def update_site(id: str):
    """ Update a site """
    stack_name = id
    if request.method == "POST":
        file_url = request.form.get("file-url")
        if file_url:
            site_content = requests.get(file_url).text
        else:
            site_content = str(request.form.get("site_content"))
        
        try:
            def pulumi_program():
                create_pulumi_program(str(site_content))
            
            stack = auto.select_stack(stack_name=stack_name,
                    project_name=current_app.config["PROJECT_NAME"],
                    program=pulumi_program)
            stack.set_config("aws_region", auto.ConfigValue("us-east-1"))
            # Deploy the site
            stack.up(on_output=print)
            flash(f"Site '{stack_name}' was updated!", category="success")
        except auto.ConcurrentUpdateError:
            flash(f"Error: Site '{stack_name} has an update in progress'", category="danger")
        except Exception as exp:
            flash(str(exp), category="danger")
        return redirect(url_for("sites.list_sites"))
    
    stack = auto.select_stack(stack_name=stack_name,
            project_name=current_app.config["PROJECT_NAME"],
            program=lambda: None)
    
    outs = stack.outputs()
    content_output = outs.get("website_content")
    if content_output:
        content = content_output.value
    else:
        content = None
    return render_template("sites/update.html", name=stack_name, content=content)


