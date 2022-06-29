Sneakers.configure(amqp: ENV['RABBIT_AMQP'],
                   daemonize: false,
                   prefetch: 15,
                   threads: 15)
Sneakers.logger.level = Logger::INFO # the default DEBUG is too noisy