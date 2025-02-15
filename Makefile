.PHONY: clean clean-test clean-pyc clean-build docs help

.DEFAULT_GOAL := help

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test clean-docs ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache/

clean-docs: ## remove mkdocs site
	rm -fr site/

lint: ## check style with flake8
	python -m flake8 --show-source src tests setup.py

test: ## run tests quickly with the default Python
	pytest

tox:  ## alias so "make tox" works
	tox

docs: ## generate HTML documentation
	pip install mkdocs
	mkdocs build

servedocs: docs ## compile the docs watching for changes
	mkdocs serve

VERSION := v$(shell python setup.py --version)

release: clean ## package and upload a release
	python setup.py sdist
	python setup.py bdist_wheel
	twine upload dist/*
	@echo "pushing tags"
	git tag $(VERSION)
	git push --tags

dist: clean ## builds source and wheel package
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

install: clean ## install the package to the active Python's site-packages
	python setup.py install
