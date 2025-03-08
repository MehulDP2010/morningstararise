from flask import Flask, render_template

app = Flask(__name__, template_folder='templates')

@app.route("/")  # ✅ Home Page
def home():
    return render_template("index.html")

@app.route("/about")  # ✅ About Page
def about():
    return render_template("about.html")

@app.route("/contact")  # ✅ Contact Page
def contact():
    return render_template("contact.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
