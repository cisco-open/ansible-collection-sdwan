# Copyright 2024 Cisco Systems, Inc. and its affiliates

# Install git
RUN apt-get update && apt-get install -y git

# Clone your repository
RUN git clone https://github.com/your_username/your_repository.git

# Verify Python version
RUN python3 --version

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Switch to your repository directory
WORKDIR /your_repository

# Install your project dependencies
RUN poetry install

# Install Ansible Galaxy requirements
RUN ansible-galaxy install -r requirements.yml
