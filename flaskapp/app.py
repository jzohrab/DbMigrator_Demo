from flask import Flask, render_template

import os, sys
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
toppath = os.path.join(os.path.dirname(CURRENT_DIR), '..')
sys.path.append(os.path.dirname(toppath))

# import event
# from event import repository
from event.repository import Repository
# from event import model

app = Flask(__name__)

@app.route("/")
def main():
    repo = Repository()
    talks = repo.get_all_talks()
    return render_template('index.html', result=talks)

if __name__ == "__main__":
    # app.debug = True
    app.run()
