function interpolant = interpolator(x_table, y_table, lookup_value)

interpolant = NaN;

if ( 3 == nargin )
  [closest_value, closest_index] = min(abs(lookup_value-x_table))
  if ( lookup_value > x_table(closest_index) )
    if ( closest_index < length(x_table) )
      s1 = (lookup_value             - x_table(closest_index)) / ...
           (x_table(closest_index+1) - x_table(closest_index))
      s0 = 1-s1;
      interpolant = s1 * y_table(closest_index+1) + s0 * y_table(closest_index)
    end
  else
    if ( closest_index > 1 )
      s1 = (lookup_value           - x_table(closest_index-1)) / ...
           (x_table(closest_index) - x_table(closest_index-1))
      s0 = 1-s1;
      interpolant = s1 * y_table(closest_index) + s0 * y_table(closest_index-1)
    end
  end
end

%! assert_nan(interpolator(),'does not return error with < 3 arguments')
%! assert_nan(interpolator([0,1],[2,4],5),'does not return error with high lookup-value')
%! assert_nan(interpolator([0,1],[2,4],-1),'does not return error with low lookup-value')
%! assert_equal(3,interpolator([0,1],[2,4],0.5),'does not return error with outside lookup-value')

