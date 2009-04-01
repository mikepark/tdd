function interpolant = interpolator(x_table, y_table, lookup_value)

interpolant = NaN;

if ( 3 == nargin )
  s2 = (lookup_value - x_table(1)) / ...
       (x_table(2)   - x_table(1));
  s1 = 1-s2;
  interpolant = s2 * y_table(2) + s1 * y_table(1);
end

%! assert_nan(interpolator(),'does not return error with < 3 arguments')
%! assert_equal(3,interpolator([0,1],[2,4],0.5),'does not return midpoint value')
%! assert_equal(2,interpolator([0,1],[2,4],0.0),'does not return endpoint value')

