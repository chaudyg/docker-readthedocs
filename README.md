

ReadTheDocs
===========
# Quick start 

Start the container
```
docker run -ti --rm --name rtd -p 8000:8000 chaudyg/readthedocs
```

Login
http://DOCKERHOST:8000/admin

# Production version
Use the following commands to start the different containers
```
# Data volume
docker run -d --name=rtddata chaudyg/readthedocs
# Start gunicorn
docker run -d --name=rtd -p 8000:8000 --volumes-from=rtddata chaudyg/readthedocs
# Start nginx
docker run -d --name=nginx -p 80:80 --link=rtd:rtd --volumes-from=rtddata nginx
```
