# Container image that runs your code
FROM python:3.7-slim

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

COPY check_issue.py /check_issue.py

COPY Pipfile.lock /Pipfile.lock

WORKDIR /

# Needed because Pipenv will not install from Pipfile.lock without Pipfile existing.
# See https://github.com/pypa/pipenv/issues/3524
RUN touch Pipfile

RUN pip install pipenv

RUN pipenv sync

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
