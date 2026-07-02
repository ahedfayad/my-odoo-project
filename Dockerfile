FROM ubuntu:24.04
# 1. System Dependencies
RUN apt-get update && apt-get install -y \
    python3.12 \
    python3-pip \
    python3-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libtiff5-dev \
    libjpeg8-dev \
    libpq-dev \
    npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g rtlcss

WORKDIR /app

# 2. Copy only requirements first (Better for build caching)
COPY requirements.txt .

# 3. Install Python Dependencies
# We use --break-system-packages because Ubuntu 24.04 
# enforces managed environments by default
RUN pip3 install --break-system-packages -r requirements.txt

# 4. Copy the rest of the code
COPY . .

# (Optional) Run your script if it does extra configuration

EXPOSE 8069

CMD ["python3", "odoo-bin", "--config", "debian/odoo.conf"]
