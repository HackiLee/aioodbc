# Some simple testing tasks (sorry, UNIX only).

FLAGS=


flake:
	flake8 aioodbc tests examples setup.py

test: flake
	py.test -s $(FLAGS) ./tests/

vtest:
	py.test -s -v $(FLAGS) ./tests/

cov cover coverage: flake
	py.test -s -v  --cov-report term --cov-report html --cov aioodbc ./tests
	@echo "open file://`pwd`/htmlcov/index.html"
clean:
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -f `find . -type f -name '@*' `
	rm -f `find . -type f -name '#*#' `
	rm -f `find . -type f -name '*.orig' `
	rm -f `find . -type f -name '*.rej' `
	rm -f .coverage
	rm -rf coverage
	rm -rf build
	rm -rf htmlcov
	rm -rf dist

doc:
	make -C docs html
	@echo "open file://`pwd`/docs/_build/html/index.html"

docker_build:
	make -C ci build

docker_test:
	docker run -v /$$(pwd):/aioodbc -v /var/run/docker.sock:/var/run/docker.sock --name aioodbc-test-$$(date +%s) --net=host -it jettify/aioodbc-test:latest py.test -sv tests $(FLAGS)

docker_cov:
	docker run -v /$$(pwd):/aioodbc -v /var/run/docker.sock:/var/run/docker.sock --name aioodbc-test-$$(date +%s) --net=host -it jettify/aioodbc-test:latest py.test -sv --cov-report term --cov-report html --cov tests --cov aioodbc $(FLAGS)

docker_clean:

.PHONY: all flake test vtest cov clean doc
