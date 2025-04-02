import pymysql
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Welcome to Flask on AWS!</h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
import pymysql
from flask import Flask

app = Flask(__name__)

def connect_db():
    return pymysql.connect(
        host="your-rds-endpoint",
        user="your-username",
        password="your-password",
        database="your-database"
    )

@app.route("/")
def home():
    connection = connect_db()
    cursor = connection.cursor()
    cursor.execute("SELECT 'Hello from Database!'")
    result = cursor.fetchone()
    connection.close()
    return f"<h1>{result[0]}</h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

