import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

EXCLUDE_DIRS = [
    os.path.join(BASE_DIR, 'ds_venv'),
    os.path.join(BASE_DIR, '_pycache_'),
]

def crear_init_en_carpetas(base_dir):
    for root, dirs, files in os.walk(base_dir):
        if any(root.startswith(excluded) for excluded in EXCLUDE_DIRS):
            print(f'Se excluye: {root}')
            continue

        init_file = os.path.join(root, '__init__.py')
        if not os.path.exists(init_file):
            with open(init_file, 'w') as f:
                f.write('# This __init__.py file makes this directory a Python package.\n')
            print(f'Creado: {init_file}')
        else:
            print(f'Ya existe: {init_file}')

crear_init_en_carpetas(BASE_DIR)