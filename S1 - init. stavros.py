# -*- coding: utf-8 -*-
"""
Éditeur de Spyder

Ceci est un script temporaire.
"""

# 1)Use the « conda » or « pip » command in the terminal
#C:\Users\d-minassian>conda list
## packages in environment at C:\Program Files (x86)\Anaconda:
##
#_license                  1.1                      py27_1    defaults
#alabaster                 0.7.6                    py27_0    defaults
#anaconda                  2.4.1               np110py27_0    defaults
# [...]


#2)Display installed packages
# @ windows command: conda
# returns:
#C:\Users\d-minassian>conda list
## packages in environment at C:\Program Files (x86)\Anaconda:
##
#_license                  1.1                      py27_1    defaults
#alabaster                 0.7.6                    py27_0    defaults
#anaconda                  2.4.1               np110py27_0    defaults
# [...]

# Usefull keyboard shortcuts
# "blockcomment" - CTRL+4
# "comment" - CTRL+1
# "runcurrentline" - F9
# "run" - F5

# Default keyboard shortcut for "runcurrentline" changed from "F9" to "CTRL+R"

#==============================================================================
#  Reading Tutorial "http://www.stavros.io/tutorials/python/"
# 
#==============================================================================
# Basic function:
# HELP
help(5) # 5 is the code for "int"
# DIRECTORY
dir() # different from R
abs.__doc__ # shows the documentation of the abs objet

# First variable management

# Python variable inc/decrementation
myvar = 3;print(myvar) # print works as in R , as well as the ";" statement
myvar += 2;print(myvar) # equivalent to myvar=myvar+2 - shortest
myvar -= 1;print(myvar)

"""This is a multiline comment.
The following lines concatenate the two strings."""

mystring = "Hello"
mystring += " world."
print mystring


# This swaps the variables in one line(!).
# It doesn't violate strong typing because values aren't
# actually being assigned, but new objects are bound to
# the old names.
myvar, mystring = mystring, myvar
print myvar mystring # doesn't work, I would like something like R.paste()
print myvar; print mystring # variables switched - strange

# DATA TYPES
# Important: index starts at 0 + negative number count from the end towards the beginning (e.g. -1 represents the last item)



sample = [1, ["another", "list"], ("a", "tuple")] # "[...]" seems to stand for list type - storing another list and a "tuple" "(...)"
mylist = ["List item 1", 2, 3.14] # Creation of a "list" with 3 items, "List item 1" being the first one (index:=0)
mylist[0] = "List item 1 again" # We're changing the item #1.
mylist[-1] = 3.21 # Here, we refer to the last item.
print(mylist) # need to get used to the print: "[ ]" are displayed in the console and must be interpreted as list

mydict = {"Key 1": "Value 1", 2: 3, "pi": 3.14} # "{...}" for "dictionnaries"
mydict["pi"] = 3.15 # This is how you change dictionary values - in other worlds we have to type the value (strange?!)

mytuple = (1, 2, 3);print mytuple[1] # Probably the R.equivalent of c()

# decimal:="." & separator:="," as R

# Calling items
print mylist[:] # empty index refers to the bounds
print mylist[0:2]
# ?!
len(mylist) # 3 => so why 0:2 does not refer to the full mylist content sinces it should represents "from item indexed 0 to item indexed 2"
print mylist[0:0] # seems that second argument (after the ":") is in fact the length to display, not the index of the end
print mylist[1:2] # -_- just display the second argument
print mylist[2:2] # should display just the 2nd argument but display an empty variable
# well the end bound is excluded (which is quite strange)
# If I want to call items 1 to 2 I must type:
print mylist[0:2] # while 0 to 2 refers to 3 items, well nevermind and get used to it -_-;
# If I want to call the entire content of the variable (but using indexes)
print mylist[:]
print mylist[0:4]
print mylist[0:]
print mylist[:4]

# Adding a third parameter, "step" will have Python step in
# N item increments, rather than 1.
# E.g., this will return the first item, then go to the third and
# return that (so, items 0 and 2 in 0-indexing).
print mylist[::2] # last argument is the step value



print "Name: %s\
Number: %s\
String: %s" % (myclass.name, 3, 3 * "-")
# His code doesn't work since "myclass" was not yet defined
# Let's use a single string for now
print "Name: %s\
Number: %s\
String: %s" % ("Dimitri", 3, 3 * "-")
# the console does not display endline properly


strString = """This is
a multiline
string."""
print strString
# but displays correctly the endline for such a string


# WARNING: Watch out for the trailing s in "%(key)s".
print "This %(verb)s a %(noun)s." % {"noun": "test", "verb": "is"}
# This is a test.
# pas bien compris
print "This %(verb)s a %(noun)s." % {"noun": "test", "verb": "hello"}
# This hello a test
print "This %(verb)s a %(noun)s." % ("noun": "test", "verb": "hello")
# => error
# Ok I think that the idea here is to shows the difference between a tuple (vector) and a dictionnary

# FLOW CONTROL STATEMENTS
# No "{...}" bloc (since it is for dictionnaries), just ":"

rangelist = range(10) # creates a list "[...]" (not a "tuper") of 10 values from 0 to 9
print rangelist

# summary: 
# for x in y: 
    # ... # ! only one command line ? How to execute several lines if there is no bloc definition such as "{...}" in R?
#
for number in rangelist:
    # Check if number is one of
    # the numbers in the tuple.
    print "Treatment of number %s" % number
    if number in (3, 4, 7, 9):
        # "Break" terminates a for without
        # executing the "else" clause.
        print "Number (%s) matches! - break" % number
        break
    else:
        print "Number (%s) does not match! - continue" % number
        # "Continue" starts the next iteration
        # of the loop. It's rather useless here,
        # as it's the last statement of the loop.
        continue
else:
    # The "else" clause is optional and is
    # executed only if the loop didn't "break".
    pass # Do nothing

if rangelist[1] == 2:
    print "The second item (lists are 0-based) is 2"
elif rangelist[1] == 3:
    print "The second item (lists are 0-based) is 3"
else:
    print "Dunno"

while rangelist[1] == 1:
    pass
# Code pas executé : c'est pas très sympa de sa part de nous faire faire une boucle infinie...
    


# FUNCTIONS
myfunction = len
print myfunction(mylist)
3

# Same as def funcvar(x): return x + 1
funcvar = lambda x: x + 1
print funcvar(1)
2
# Pas compris cette partie ci-dessus

# an_int and a_string are optional, they have default values
# if one is not passed (2 and "A default string", respectively).
def passing_example(a_list, an_int=2, a_string="A default string"):
    a_list.append("A new item") # we note here that the objets have pre-implemented functions, such as .append for list objets
    an_int = 4
    return a_list, an_int, a_string

my_list = [1, 2, 3]
my_int = 10
print passing_example(my_list, my_int)
my_list # RAS
my_int # RAS

# CLASSES
class MyClass(object):
    common = 10 # common is a common (global) variable, shared will all MyClass objet,
    def __init__(self):
        self.myvariable = 3 # self implies that this variable "myvariable" is proper to the class objet (local)
    def myfunction(self, arg1, arg2):
        return self.myvariable # Not sure: what ends the bloc? Is it the "return" statement? How do we return a NULL value?

# This is the class instantiation
classinstance = MyClass()
classinstance.myfunction(1, 2)

# This variable is shared by all classes.
classinstance2 = MyClass()
classinstance.common
classinstance2.common

# Note how we use the class name
# instead of the instance.
MyClass.common = 30
classinstance.common
classinstance2.common

# This will not update the variable on the class,
# instead it will bind a new object to the old
# variable name.
classinstance.common = 10 # in this case we directly modify the variable "common" of the perticular objet 
# => break the link with the global objet
classinstance.common

classinstance2.common

MyClass.common = 50
# This has not changed, because "common" is
# now an instance variable.
classinstance.common

classinstance2.common


# This class inherits from MyClass. The example
# class above inherits from "object", which makes
# it what's called a "new-style class".
# Multiple inheritance is declared as:
# class OtherClass(MyClass1, MyClass2, MyClassN)
class OtherClass(MyClass):
    # The "self" argument is passed automatically
    # and refers to the class instance, so you can set
    # instance variables as above, but from inside the class.
    def __init__(self, arg1):
#        self.myvariable = 3
        print arg1


classinstance = OtherClass("hello")
hello
# This new objet "otherclass" retrieve every properties of the MyClass objet
# but we can redifine some I guess:
class OtherClass2(MyClass):
    # The "self" argument is passed automatically
    # and refers to the class instance, so you can set
    # instance variables as above, but from inside the class.
    def __init__(self, arg1):
        self.myvariable = 5
        print arg1
classinstance2 = OtherClass2("")
print classinstance2.myvariable
        
# This class doesn't have a .test member, but
# we can add one to the instance anyway. Note
# that this will only be a member of classinstance.
classinstance.test = 10
classinstance.test
# add a property "test" for the local variable only
# I don't know if it is possible to add a global property (something like an update)

old_class=OtherClass2("old")
# update of OtherClass2 object
class OtherClass2(MyClass):
    # The "self" argument is passed automatically
    # and refers to the class instance, so you can set
    # instance variables as above, but from inside the class.
    def __init__(self, arg1):
        self.myvariable = 5
        print arg1
        self.newvariable=30
        
print old_class.newvariable
# returns an error:
# Traceback (most recent call last):
#  File "<stdin>", line 1, in <module>
#AttributeError: 'OtherClass2' object has no attribute 'newvariable'
# Faudra faire autrement


# EXCEPTIONS
10/0
10/"r"
def some_function(arg1):
    try:
        # Division by zero raises an exception
        10 / arg1
    except ZeroDivisionError:
        print "Erreur ! Division par 0 !"
    except TypeError:
        print "Erreur ! Division par une lettre !"
    else: # Exception didn't occur, we're good.
     print "Bravo !Division réussie !"
    finally:
        # This is executed after the code block is run
        # and all exceptions have been handled, even
        # if a new exception is raised while handling.
        print "We're done with that."

some_function(20)
some_function(0)
some_function("a")
# all error handled

import random
from time import clock

randomint = random.randint(1, 100) # allow the generation of uniform figures? => checker la véracité du moteur
print randomint

# FILE MANAGEMENT

# Creation of a file on my desktop
fo = open("C:\\Users\d-minassian\Desktop\Python_test.txt")
# returns an error: IOError: [Errno 2] No such file or directory: 'C:\\Users\\d-minassian\\Desktop\\Python_test.txt'
fo = open("C:\\Users\d-minassian\Desktop\Python_test.txt","wb")
# no error: parameter "wb" creates the file (overwrite if exists !!!)
# Adding a new line in it (auto save)
fo.write( "I am testing Python.\n And the new line parameter.\n Don't know if it works.") # \n doesn't work
# Closing the connexion
fo.close()





# INTERFACE
str = raw_input("Enter your input: ");
print "Received input is : ", str
