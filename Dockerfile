FROM python:3.9-slim

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
COPY target/requirements_target.txt .

RUN python -m pip install --upgrade pip && \
    pip install -r requirements.txt \
    pip install -r requirements_target.txt

RUN printf "\nalias ls='ls --color=auto'\n" >> ~/.bashrc
RUN printf "\nalias ll='ls -alF'\n" >> ~/.bashrc

ENV PACKAGE_PATH="/workspace/src/package"
# CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
