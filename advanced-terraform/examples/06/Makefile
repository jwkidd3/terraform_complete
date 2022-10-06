help:						
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

blah: blah.o
	cc blah.o -o blah # Runs third

blah.o: blah.c
	cc -c blah.c -o blah.o # Runs second

blah.c:
	echo "int main() { return 0; }" > blah.c # Runs first

# clean:
# 	rm -f blah blah.c blah.o

############

# foo = ok

# all:
# ifeq ($(foo), ok)
# 	echo "foo equals ok"
# else
# 	echo "nope"
# endif

############

# nullstring =
# foo = $(nullstring) # end of line; there is a space here

# all:
# ifeq ($(strip $(foo)),)
#     echo "foo is empty after being stripped"
# endif
# ifeq ($(nullstring),)
#     echo "nullstring doesn't even have spaces"
# endif

############

# foo = $(bar)

# all:
# ifdef foo
#     echo "foo is defined"
# endif
# ifdef AWS_BAR
#     echo "but AWS_BAR is not"
# endif