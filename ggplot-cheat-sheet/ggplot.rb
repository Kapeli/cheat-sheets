cheatsheet do
    title 'ggplot'
    docset_file_name 'ggplot'
    keyword 'ggplot'
    category do
        id 'Basics'
        entry do
            name 'Overview'
            notes <<-'END'
            Transitioning from yhat's port to plotnine. Some stuff here may be out of date.
            END
        end
        entry do
            name 'Import and links'
            notes <<-'END'
            Docs: 
            
            * <https://plotnine.readthedocs.io/en/latest/>
            * <https://mizani.readthedocs.io/en/stable/formatters.html>

            ```
            from plotnine import *
            from mizani.formatters import *
            ```
            END
        end
        entry do
            name 'Plot two columns of data'
            notes <<-'END'
            **DON'T DO THIS!**

            Don't store your data columnwise. Instead, do it rowwise.

            Don't do this:

            ```
            |time|control|experiment|
            |----|-------|----------|
            |0   |     12|        24|
            |1   |     13|        25|
            ```

            Instead, do this:

            ```
            |time|  group    |     count|
            |----|-----------|----------|
            |0   |control    |        12|
            |0   |experiment |        24|
            |1   |control    |        13|
            |1   |experiment |        25|
            ```

            Then you can do plots like:

            ```python
            ggplot(df, aes(x='time',y='count',color='group')) + geom_line()
            ```
            END
        end
        entry do
            name 'Plot against index'
            notes <<-'END'

            Give the index a name, and then call reset_index:

            ```
            df.index.name = "time"
            ggplot(df.reset_index(), aes(x='time', y='samples')) + geom_line()
            ```
            END
        end
        entry do
            name 'Colors'
            notes <<-'END'

            ```
            ggplot(df, aes(x="time", y="count", color="group")) +\
            geom_line() + \
            scale_color_manual(values=["blue", "red"]) 
            ```
            END
        end
    end
    category do
        id 'Scatter plots'
        entry do
            name 'Scatter plot with dates'
            notes <<-'END'

            When doing `geom_point` with dates, the x-axis doesn't scale properly without a call to `scale_x_date`.
            The label format uses [strftime][1] syntax.

            [1]: https://docs.python.org/3/library/time.html#time.strftime


            ```python
            from ggplot import *

            ggplot(aes(x='date', y='widgets'), data=data) + geom_point() + scale_x_date(labels='%Y')
            ```

            Note that you can put conversion logic in there. For example, if "start" is in epoch time:

            ```python
            ggplot(aes(x='pd.to_datetime(start, unit="s")', y='widgets'), data=data) + geom_point() + scale_x_date(labels='%Y')
            ```
            END
        end
        entry do
            name 'Color coded multiple series'
            notes <<-'END'
            ```python
            from ggplot import *
            df = ...
            ggplot(aes(x='xvals', y='yvals', color='kind'), data=df) + geom_point()
            ```
            END
        end
        entry do
            name 'Fit a linear regression curve'
            notes <<-'END'
            ```python
            ggplot(aes(x='xvals', y='yvals'), data=df) + \
            geom_point() + \
            stat_smooth(method="lm", color="red", size=2)
            ```
            END
        end
    end
    category do
        id 'Facet plots'
        entry do
            name 'Facet scatterplot with comon axes'
            notes <<-'END'
            ```python
            from ggplot import *
            df = ...
            ggplot(aes(x='xvals', y='yvals'), data=df) + geom_point() + facet_wrap('kind', scales='fixed')
            ```
            END
        end
        entry do
            name 'Linear regression per facet'
            notes <<-'END'
            Just add `stat_smooth` as you would for a regular plot.
            END
        end
    end
    category do
        id 'Axes and titles'
        entry do
            name 'Labels and title'
            notes <<-'END'
            ```
            xlab("x label") + ylab("y label") + ggtitle("title")
            ```
            END
        end
        entry do
            name 'axis labels'
            notes <<-'END'
            ```
            ggplot(data, aes('date', 'counts')) + geom_point() + xlab("Date") + ylab("Counts") \
            + labs(title="Counts and Dates") 
            ```
            END
        end
        entry do
            name 'No x tick marks'
            notes <<-'END'
            ```
            ggplot(...) + ... + theme(axis_text_x=element_blank())
            
            ```
            END
        end
        entry do
            name 'Date break examples'
            notes <<-'END'
            See <https://github.com/has2k1/plotnine-examples/blob/master/plotnine_examples/tutorials/miscellaneous-manipulating-date-breaks-and-date-labels.ipynb>
            END
        end
        entry do
            name 'Vertical line with x axis is timestamps'
            notes <<-'END'
            ```python
            # Workaround for https://github.com/has2k1/plotnine/issues/97
            from matplotlib.dates import date2num

            geom_vline(xintercept=date2num(ts))
            ```
            END
        end
        entry do
            name 'Format x-axis tick labels as years'
            notes <<-'END'
            ```
            from mizani.formatters import date_format
            ...
            ... + scale_x_datetime(labels=date_format("%Y-%m-%d %H:%M:%S"))
            ```

            Note that the mizani.formatters.date_format call returns a function
            that is called on a series of data.
            END
        end
        entry do
            name 'Break on year boundaries and format as year'
            notes <<-'END'
            ```
            from mizani.breaks import date_breaks
            from mizani.formatters import date_format
            ...
            + scale_x_datetime(breaks=date_breaks('1 year'), labels=date_format('%Y'))
            ```
            END
        end
        entry do
            name 'Custom tick labels'
            notes <<-'END'

            You can pass the `labels` argument in a scale function as either a
            list of strings or a callable whose input is a list of breakpoints
            and whose output is a list of strings.

            Here's an example where we only want to show tick labels for the
            first day of a year.

            ```
            + scale_x_datetime(labels=lambda lst: [x.year if x.month==1 and x.day==1 else "" for x in lst])
            ```
            END
        end
        entry do
            name 'Date range'
            notes <<-'END'
            ```
            scale_x_continuous(name="Start time", limits=(pd.Timestamp('2015-01-01'), pd.Timestamp('2016-09-01')))
            ```
            END
        end
    end
    category do
        id 'Other plots'
        entry do
            name 'ecdf'
            notes <<-'END'
            ```
            def ecdf(ser, label):
                sq = ser.value_counts()
                ecdf = sq.sort_index().cumsum()*1./len(ser)
                d = pd.DataFrame(ecdf.rename("ecdf"))
                d[label] = d.index
                p = ggplot(d, aes(x=label, y="ecdf")) + geom_line()
                return p
            ```
            END
        end
    end
end
