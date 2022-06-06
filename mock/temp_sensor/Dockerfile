FROM python:3.9.12

RUN pip3 install Flask git+https://github.com/vrachieru/tplink-smartplug-api.git

COPY app.py /app/app.py

WORKDIR /app

RUN export FLASK_APP=app.py

CMD ["python3", "-m", "flask", "run", "-h", "0.0.0.0"]