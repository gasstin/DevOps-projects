(Readme in progress)
# Heroku clone

## Introduction
This project was created following a Freecodecamp tutorial. Consist in an application that permits users to create, uptade and check static web sites and
virtual machines hosted in [AWS](https://aws.amazon.com/es/), like Heroku. Backend's app uses Python and Flask framework, and HTML, CSS files to Frontend. 

## Files
### Setup
  - `setup_enviroment.sh` it's a script that install [Pulumi](https://www.pulumi.com/) and AWS CLI because are necesaries to run the app.
  - It's necesary configure the AWS credentials locally using `aws configure` and following the steps.

### Templates
Here are all HTML templates that are rendered by Flask.

  - `sites` templates to use in Sites configuration.
  - `virtual_machines` templates to use in Virtual Machine to use in VM configuration.

### Python Files

  - `app.py` contains the application core.
  - `sities.py` contains all the routes created to Static Web Sites management.
  - `virtual_machines.py` contains all the routes created to Virtual Machines management.

Thanks to [Beau Carnes](http://carnes.cc/) for share this tutorial.
