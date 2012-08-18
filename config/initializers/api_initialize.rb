SECRETS = YAML.load_file("#{Rails.root}/config/secrets.yml")['secrets']
PARAMETERS = YAML.load_file("#{Rails.root}/config/parameters.yml")['parameters']