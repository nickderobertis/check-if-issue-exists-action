# Container image that runs your code
FROM python:3.7-slim

WORKDIR /

RUN pip install pipenv

COPY Pipfile.lock /Pipfile.lock

# Needed because Pipenv will not install from Pipfile.lock without Pipfile existing.
# See https://github.com/pypa/pipenv/issues/3524
COPY Pipfile /Pipfile

RUN pipenv sync

COPY entrypoint.sh /entrypoint.sh

COPY check_issue.py /check_issue.py

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
