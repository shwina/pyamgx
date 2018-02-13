.PHONY:clean

pyamgx:
	python setup.py build_ext
	pip install -e . --user

clean:
	rm -f *.so
	rm -f pyamgx/*.c
	rm -f -r build/

.PHONY:allclean
allclean: clean
	rm -f -r *.egg-info
