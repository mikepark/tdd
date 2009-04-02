function [r] = f(x,y,z)

if nargin <3
    r = NaN;
    return
end
s2 = z-x(1)/(x(2)-x(1));

s1 = 1-s2;

r = s1*y(1)+s2*y(2);

%! assert_equal(3.5,f([1 2],[3 4],1.5))
%! assert_equal(3,f([1 2],[3 4],1))
%! assert_nan(f(),'expecting NaN for no args')