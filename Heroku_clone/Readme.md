(Readme in progress)
# Heroku clone

## Introduction
This project was created following a Freecodecamp tutorial. Consist in an application that permits users to create, uptade and check static web sites and
virtual machines hosted in AWS, like Heroku. Backend's app uses Python and Flask framework, and HTML files to Frontend. 

## Files
### Setup
  - `setup_enviroment.sh` it's a script that install Pulumi and AWS CLI because are necesaries to run the app.
  - It's necesary configure the AWS credentials locally using `aws configure` and following the steps.

### Templates
Here are all HTML templates that are rendered by Flask.

  - `sites` templates to use in Sites configuration
  - `virtual_machines` templates to use in Virtual Machine to use in VM configuration.

### Py Files

  - `app.py`
  - `sities.py`
