% DOC_OLD_README Old readme information, should move into other doc files.
%
% I've tried to put most of the files that are relevant to stochastic
% Galerkin methods into the main directory. I think that searching is
% easier that way, because any hierarchy you would impose, gets
% arbitrary at some point and makes searching (and more importantly
% finding ;-) much more difficult for others. So, only files that are
% really inessential for stochastic methods have been moved to
% subdirs. The following subdirs have been established so far:
%
% util - contains general purpose methods, which you could use
% anywhere (I mean any project not necessarily related to SG)
%
% munit - contains a unit testing framework for matlab/octave with some
% focus on numerics (inexact test for num. algorithms and fuzzy tests
% for MC methods)
%
% simplefem - contains some routines for primitive FEM programs, like
% creation of mass and stiffness matrices and grid manipulation (it's
% really primitive and just meant for testing and demo purposes)
%
% personal - some stuff the author just made for himself (for talks, for
% enlightenment or just for fun)
%
% experimental - some routines which aren't anywhere near being stable
% yet or where the interface is still in a state of flux
%
% Maybe in the future, the first three subdirs should get their own
% project and get linked in via svn:externals (but should also get
% distributed with every snapshot/release package). The last two subdirs
% should probably (read: definitely) go into a branch, but the author is
% currently to busy (read: lazy) for that.
%
% An overview over all files and what they do can be found in the
% Contents.m file. Moreover, every file should contain a help section
% with information on parameters, output and how to use that file. If
% not, please complain to the author.
%
