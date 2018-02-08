.PHONY:clean
clean:
	rm -f *.so
	rm -f pyamgx/*.c
	rm -f -r build/

.PHONY:allclean
allclean: clean
	rm -f -r *.egg-info
