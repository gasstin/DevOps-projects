import os
from flask import Flask
import pulumi.automation as auto

def ensure_plugins():
    ws = auto.LocalWorkspace()
    ws.install_plugin("aws", "v4.0.0")

def create_app():
    ensure_plugins()
    app = Flask(__name__, instace_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY="secret",
        PROJECT_NAME='heroku_clone',
        PULUMI_ORG=os.environ.get("PULUMI_ORG"),
    )

    app.route('/', methods=["GET"])
    def index():
            return render_template("index.html")
    
    from . import sities

    app.register_blueprint(sities.bp)

    from . import virtual_machines

    app.register_blueprint(virtual_machines.bp)

    return app

# if '__name__' == '__main__':
#     app.run()