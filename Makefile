build-package:
	rm -rf build
	rm -rf pleione.egg-info
	rm -rf __pycache__
	python3 setup.py bdist_wheel sdist

clean-package:
	python3 setup.py clean

install-package:
	python3 setup.py clean build install
