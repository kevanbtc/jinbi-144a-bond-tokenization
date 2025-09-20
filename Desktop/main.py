from flask import Flask
app = Flask(__name__)
@app.route('/health', methods=['GET'])
def health():
    return {"status": "ok"}
if __name__ == '__main__':
   app.run(debug=True)  # run the application in debug mode on port 5000 (you can change it as per your needs). This is a good practice for development, but not recommended to use this command when deploying applications! Use gunicorn or uWSGI instead of Flask's built-in server.
