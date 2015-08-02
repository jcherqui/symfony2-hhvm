Docker symfony2 hhvm
============

Symfony is a set of PHP Components, a Web Application framework, a Philosophy, and a Community — all working together in harmony.

Quick Start
-----------

Install symfony2

```bash
sudo curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony
symfony new my_project
```

Add your project directory as a volume directory with the argument -v /your-path/files/:/var/www/ like this

`docker run -d -p 80:80 -v $PWD/my_project:/var/www/ -it jcherqui/symfony2-hhvm:latest`

Point your browser to `http://127.0.0.1`

Notes
-----

If you want access to `http://127.0.0.1/app_dev.php` ; add the parameter `--net=host`

License
----

MIT


**Free Software, Hell Yeah!**
