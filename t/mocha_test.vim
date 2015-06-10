source plugin/mocha.vim

call vspec#hint({'scope': 'mocha#scope()', 'sid': 'mocha#sid()'})

describe "GetCorrectCommand()"
  context "when filetype=javascript"
    before
      set filetype=javascript
    end

    context "when g:mocha_js_command is not defined"
      it "sets the correct default command"
        call Call("s:GetCorrectCommand")
        Expect g:spec_command == "!echo mocha {spec} && mocha {spec}"
      end
    end

    context "when g:mocha_js_command is defined"
      it "uses the defined command"
        let g:mocha_js_command="customJSCommand {spec}"
        call Call("s:GetCorrectCommand")
        Expect g:spec_command == "customJSCommand {spec}"
        unlet g:mocha_js_command
      end
    end
  end

  context "when filetype=coffee"
    before
      set filetype=coffee
    end
    after
      set filetype=
    end

    context "when g:mocha_coffee_command is not defined"
      it "sets the default command"
        call Call("s:GetCorrectCommand")
        let l:cmd = "mocha --compilers 'coffee:coffee-script/register' {spec}"
        Expect g:spec_command == '!echo ' . l:cmd . ' && ' . l:cmd
      end
    end

    context "when g:mocha_coffee_command is defined"
      it "uses the defined command"
        let g:mocha_coffee_command="customCoffeeCommand {spec}"
        call Call("s:GetCorrectCommand")
        Expect g:spec_command == "customCoffeeCommand {spec}"
        unlet g:mocha_coffee_command
      end
    end
  end

  context 'when filetype!=coffee|js && g:mocha_coffee is not defined'
    context 'when major_filetype is js'
      before
        write tmp.js
      end
      after
        !rm tmp.js
      end
      it 'sets default javascript command'
        call Call("s:GetCorrectCommand")
        Expect g:spec_command == "!echo mocha {spec} && mocha {spec}"
      end
    end

    context 'when major_filetype is coffee'
      before
        write tmp.coffee
      end
      after
        !rm tmp.coffee
      end
      it 'sets default coffee command'
        call Call("s:GetCorrectCommand")
        let l:cmd = "mocha --compilers 'coffee:coffee-script/register' {spec}"
        Expect g:spec_command == "!echo " . l:cmd . " && " . l:cmd
      end
    end
  end

end
