#!/bin/sh

# ====== CREATE NEW PROJECT IF IT NOT EXIST ======
APP_FOLDER_PATH=$APP_DIR/$APP_FOLDER
if ! [ -d "$APP_FOLDER_PATH" ]; then
  echo "'$APP_FOLDER_PATH' does not exist. A new django project will be create in the '$APP_FOLDER_PATH' directory"
  wget https://github.com/gaiiiuiiia/django-template/archive/refs/heads/master.zip\
      && unzip master* -d ./master \
      && mv ./master/django*/ $APP_FOLDER_PATH \
      && rm -rf ./master* \
      && rm -rf ./master
  pip install -r $APP_FOLDER_PATH/requirements/$ENV.txt
fi

# ====== CHECK IF manage.py file in application directory ======
if ! [ -f "$APP_FOLDER_PATH/manage.py" ]; then
  echo "Incorrect directory! The file 'manage.py' is not here!"
  echo "Please check the '$APP_FOLDER_PATH' directory."
  echo "EXIT :("
  exit 1
fi

# ====== CREATE A STATIC DIRECTORY IF IT NOT EXIST ======
STATIC_FOLDER_PATH=$APP_DIR/$APP_FOLDER/$STATIC_FILES_FOLDER
if ! [ -d "$STATIC_FOLDER_PATH" ]; then
  echo "create static at $STATIC_FOLDER_PATH"
  mkdir $STATIC_FOLDER_PATH
fi

# ====== CREATE A MEDIA DIRECTORY IF IT NOT EXIST ======
MEDIA_FOLDER_PATH=$APP_DIR/$APP_FOLDER/$MEDIA_FILES_FOLDER
if ! [ -d "$MEDIA_FOLDER_PATH" ]; then
  echo "create media at $MEDIA_FOLDER_PATH"
  mkdir $MEDIA_FOLDER_PATH
fi

cd $APP_FOLDER_PATH

sleep 10

python manage.py migrate
python manage.py createcachetable
python manage.py collectstatic --noinput

if [ $RUN_MODE = dev_auto ]; then
  echo "STARTING DJANGO SERVER..."
  python manage.py runserver 0.0.0.0:8000
fi
if [ $RUN_MODE = dev_manual ]; then
  echo "CONTAINER IS CREATED. START DEVELOP SERVER MANUALLY..."
  sh
fi
if [ $RUN_MODE = debug ]; then
  echo "RUNNING IN DEBUG MODE! SERVER ISN'T START. TRY TO SETUP A DEBUG IN YOUR IDE AND RUN IN THROUGH IDE."
  echo "FOR MORE INFORMATION SEE https://testdriven.io/blog/django-debugging-pycharm/"
fi
if [ $RUN_MODE = staging ]; then
  echo "STARTING GUNICORN..."
  gunicorn $APP_FOLDER.wsgi --bind 0.0.0.0:8000
fi

exec "$@"
