cheatsheet do
    title 'groovy'
    docset_file_name 'groovy'
    keyword 'groovy'
    category do
        id 'Maps'
        entry do
            name 'Literal'
            notes <<-'END'
            ```
            [name: "foo", "age": 43]
            
            ```
            END
        end
        entry do
            name 'Interpolate variable for key'
            notes <<-'END'
            ```
            def name = "key"
            [(name): "foo"]
            ```
            END
        end
    end
end
