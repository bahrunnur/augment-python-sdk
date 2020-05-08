# Copyright (c) 2020 AccelByte Inc. All Rights Reserved.
# This is licensed software from AccelByte Inc, for limitations
# and restrictions contact your company contract manager.

SVC=justice-augment-python-sdk
BUILDER=$(SVC)-builder

RUN=docker run --rm \
	-v $(CURDIR):/workspace/$(SVC) \
	-w /workspace/$(SVC)

.PHONY: init test

build:
	docker build -t $(BUILDER) .
	$(RUN) $(BUILDER) cp tox.ini tox.orig.ini
	@$(RUN) $(BUILDER) sed -i 's/<ADMIN_USERNAME>/${ADMIN_USERNAME}/g' tox.ini
	@$(RUN) $(BUILDER) sed -i 's/<ADMIN_PASSWORD>/${ADMIN_PASSWORD}/g' tox.ini
	@$(RUN) $(BUILDER) sed -i 's/<IAM_CLIENT_ID>/${IAM_CLIENT_ID}/g' tox.ini
	@$(RUN) $(BUILDER) sed -i 's/<IAM_CLIENT_SECRET>/${IAM_CLIENT_SECRET}/g' tox.ini

clean:
	$(RUN) $(BUILDER) cp -f tox.orig.ini tox.ini
	$(RUN) $(BUILDER) rm tox.orig.ini

test:
	$(RUN) $(BUILDER) tox

publish:
	pip install twine
	python setup.py sdist bdist_wheel
	twine upload dist/*
	rm -rf build dist .egg requests.egg-info
