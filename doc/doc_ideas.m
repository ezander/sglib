% DOC_IDEAS Contains some ideas that are underlying or should be implemented in SGLIB.
%
%   * Idea 1: Freedom of the user: use whatever other framework you like,
%             make everything in and out explicit
%   * Idea 2: Separate functions into public and private interface. Public
%             has all the option passing and consistency checking, and in
%             private is the pure algorithm.
%   * Idea 3: Functions should have their own unit test each, and should
%             probably be named something like ut_*.m or utest_*.m, so that
%             unittest_ can again be used freely for some free form testing.
%   * Idea 4: Timing methods could go into prof_*.m and should remain there
%             so that testing algorithm modifications can be repeated
%             easily.
%   * Idea 5:
