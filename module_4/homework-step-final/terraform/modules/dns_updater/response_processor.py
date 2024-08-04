# terraform/modules/dns_updater/response_processor.py

# Recursive processing of the responses
def flatten_to_string(obj, parent_key='', sep='_'):
    items = {}
    if isinstance(obj, dict):
        for k, v in obj.items():
            new_key = f"{parent_key}{sep}{k}" if parent_key else str(k)
            items.update(flatten_to_string(v, new_key, sep=sep))
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            new_key = f"{parent_key}{sep}{i}" if parent_key else str(i)
            items.update(flatten_to_string(item, new_key, sep=sep))
    else:
        items[parent_key] = str(obj)
    return items