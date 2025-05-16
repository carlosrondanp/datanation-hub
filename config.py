import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

DATA_DIR = os.path.join(BASE_DIR, 'data')
SCRIPTS_DIR = os.path.join(BASE_DIR, 'scripts')
MODELS_DIR = os.path.join(BASE_DIR, 'models')
SRC_DIR = os.path.join(BASE_DIR, 'src')
NOTEBOOKS_DIR = os.path.join(BASE_DIR, 'notebooks')

## DATA :
DATA_RAW_DIR = os.path.join(DATA_DIR, 'raw')
DATA_PROCESSED_DIR = os.path.join(DATA_DIR, 'processed')
DATA_EXTERNAL_DIR = os.path.join(DATA_DIR, 'external')


# SRC:
SCRIPTS_QUERIES_DIR = os.path.join(SRC_DIR, 'queries')

## MODELS:
MODELS_WOE = os.path.join(MODELS_DIR, 'WOE')
MODELS_TRAINED_DIR = os.path.join(MODELS_DIR, 'trained')