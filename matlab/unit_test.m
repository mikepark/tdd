% unit_test - unit testing framework for MATLAB and Octave
%
% usage: number_of_test_failures = unit_test('test_this_script.m')
% 
%  It works by executing all lines in the script to be tested
%  that begin with `%!'. Run unit_test with no arguments and see
%  the end of unit_test.m file for an example. 
%
%  Mike Park <MikePark@MIT.Edu> <MikePark.rb@GMail.Com>
%  $Revision: 1.6 $
function failures = unit_test(filename)

global unit_test_global_asserts
global unit_test_global_failures
global unit_test_global_pass
global unit_test_global_line_number

if (nargin<1)
  filename = 'unit_test';
  disp(['no argument given, filename set to ' filename])
end

if ( findstr(filename,'.m') == [(length(filename)-1)] )
else
  filename = [filename '.m'];
  disp(['the .m extension missing from script, added: ' filename])
end

unit_test_global_asserts = 0;
unit_test_global_failures = 0;
unit_test_global_pass = 0;

unit_test_fid = fopen(filename,'rt');
unit_test_global_line_number = 0;
while (1==1)
  unit_test_line = fgetl(unit_test_fid);
  unit_test_global_line_number = unit_test_global_line_number + 1;
  if ~ischar(unit_test_line); break; end
  if [1] == findstr(unit_test_line,'%!')
    unit_test_len = length(unit_test_line);
    unit_test_try = unit_test_line(3:unit_test_len);
    unit_test_catch = 'disp(unit_test_line);disp(lasterr);error(sprintf(''unit test eval error for line %d'',unit_test_global_line_number));';
    %disp(unit_test_try)
    eval(unit_test_try,unit_test_catch)
  end
end
fclose(unit_test_fid);

disp(sprintf(' %4d asserts %4d failures: %s', ...
             unit_test_global_asserts, unit_test_global_failures,filename))

if (0==unit_test_global_asserts)
  disp(sprintf('--> no asserts found in %s !!!!',filename))
end

if (0<unit_test_global_failures)
  disp(sprintf('%4d failed asserts for %s <-<',unit_test_global_failures,filename))
end

failures = unit_test_global_failures;

function success = assert(test,string)

global unit_test_global_asserts
global unit_test_global_failures
global unit_test_global_pass
global unit_test_global_line_number

unit_test_global_asserts = unit_test_global_asserts + 1;

if (test)
  unit_test_global_pass = unit_test_global_pass + 1;
else
  unit_test_global_failures = unit_test_global_failures + 1;
  if (nargin>1)
    disp(sprintf('%4d: %s', unit_test_global_line_number, string))
  else
    disp(sprintf('%4d: %s', unit_test_global_line_number, 'assert failed'))
  end
end

function assert_equal(expected,actual,string)

if ( size(expected) == size(actual) )
    success = (  isempty(find(~(expected==actual))) || ...
               ( isempty(expected) && isempty(actual) ) );
else
    success = 0==1;
end

if (nargin>2)
  assert(success,string)
else
  assert(success,'assert_equal failed')
end
if (~(success))
  disp('expected:')
  disp(expected)
  disp('actual:')
  disp(actual)
end

function assert_within(expected,actual,delta,string)

if (nargin<3); delta = 1.0e-8; end

if ( size(expected) == size(actual) )
    success = (  isempty( find( ~(abs(expected-actual)<delta) ) ) || ...
               ( isempty(expected) && isempty(actual) ) );
else
    success = 0==1;
end

if (nargin>3)
  assert(success,string)
else
  assert(success,sprintf('assert_within failed for delta %e',delta))
end
if (~(success))
  disp(sprintf('expected (within %e):',delta))
  disp(expected)
  disp('actual:')
  disp(actual)
end

%! assert(0==1)
%! assert(0==0)

%! assert(0==1,'it worked if you see this')
%! assert(0==0,'it failed if you see this')

%! assert_equal(1,1)
%! assert_equal(1,0)

%! assert_equal(1,1,'it failed if you see this')
%! assert_equal(0,1,'it worked if you see this')

%! assert_equal([],[],'empty sets are not equal')
%! assert_equal([1 2; 3 4],[1 2; 3 4])
%! assert_equal([1 2; 3 4],[1 2; 3 6],'it worked if you see this')
%! assert_equal('dog','dog')
%! assert_equal('cat','dog','it worked if you see this')

%! assert_equal([],[1 2],'it worked if you see this')
%! assert_equal([1],[1 2],'it worked if you see this')

%! assert_within(1.50,1.55,0.02)

%! assert_within(1.50,1.51,0.02,'it failed if you see this')
%! assert_within(1.50,1.55,0.02,'it worked if you see this')

%! assert_within([1 2 ; 3 4],[1.1 2.1 ; 3.1 4.1],0.2,'it failed if you see this')
%!assert_within([1 2 ; 3 4],[1.1 2.1 ; 3.1 4.1],0.01,'it worked if you see this') 
