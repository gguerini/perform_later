[![Build Status](https://secure.travis-ci.org/KensoDev/perform_later.png)](https://secure.travis-ci.org/KensoDev/perform_later)

## Overview
Perform later is a gem meant to work with the [Resque](http://github.com/defunkt/resque) queue system.

Usually, when working with Resque, you need separate "Worker" classes and you also need to do `Resque.enqueue` whenever you want to add a task to the queue.

That can be a real hassle if you are adding Resque to an existing project, it can also add quite a bit of code to your system.

`perform_later` fills this need, it offers a suite to handle all of your queuing needs, both for Objects and for ActiveRecord models.

## Why?
*Why* should you queue something for later?

You should queue something whenever the method handles some heavy lifting, some timely actions like API, 3rd party HTTP requests and more.

The basic logic is that whatever you don't need to do NOW, you should do later, this will make your site faster and the users will feel it.

## Real life use case
At [Gogobot](http://gogobot.com) whenever you post a review, there's major score calculation going on. This can sometimes take up to a minute, depending on the user graph.

The user should not wait for this on submit, it can be queued into later execution.

## Configuration
You can configure `perform_later` exactly as you configure your rails app.

Inside your `#{env}.rb` file (for example development.rb)

```ruby
config.perform_later.enabled = true # this will default to false if unset
```

## Usage

### ActiveRecord

`perform_later` comes with a special method you can use on ActiveRecord models.


```ruby

	class User < ActiveRecord::Base
	  def long_running_method
	    # Your code here
	  end
	  later :long_running_method
	
	  def long_running_method_2
	    # Your code here
	  end
	  later :long_running_method_2, queue: :some_queue_name
	
	  def lonely_long_running_method
	    # Your code here
	  end
	  later :lonely_long_running_method, :loner => true, queue: :some_queue_name
	end
	
```

```ruby
	u = User.find(some_user_id)
	u.long_running_method # Method will be queued into the :generic queue
	u.long_running_method_2 # Method will be queued into :some_queue_name queue
	u.lonely_long_running_method # Method will be queued into the :some_queue_name queue, only a single instance of this method can exist in the queue.
```

### Objects/Classes

You can of course choose to run the method off the queue, just prepend `now_` to the method name and it will be executed in sync.

```ruby
	u = User.find(some_user_id)
	u.now_long_running_method
```

If you want object methods to be queued, you will have to use the `perform_later` special method.

```ruby
	class SomeClass
		def some_heavy_lifting_method
	  	  # Your code here
	  	end
	  	
		def some_more_heavy_lifting(user_id)
	  	  # Your code here
	  	end  	
	end
	
	SomeClass.perform_later(:queue_name, :some_heavy_lifting_method)
	SomeClass.perform_later(:queue_name, :some_more_heavy_lifting, user_id)
```
 
## Contribute / Bug reports

If you have an issue with this gem, please open an issue in the main repo, it will help tons if you could supply a failing spec with that, so I can better track where the bug is coming from, if not, no worries, just report I will do my best to address it as fast and efficient as I can.

If you want to contribute (awesome), open a feature branch, base it on master.

Be as descriptive as you can in the pull request description, just to be clear what problem you are solving or what feature are you adding.