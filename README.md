

<!-- 

# Todo 

Set Dark Mode.

https://just-the-docs.github.io/just-the-docs/docs/index-test/#header-2 

-->


# RUN / DEX 


## DEPLOY

### Deploy To Dev (Codespaces)

In Codespaces terminal : 
```shell
docker run --volume="$PWD:/root/project:delegated" --publish 4000:4000 -ti mrseccubus/github-pages
```

From https://hub.docker.com/r/mrseccubus/github-pages

Then : 
https://benoit-marechal-effective-pancake-46j4vr4gvq35x95-4000.preview.app.github.dev/


### Deploy To Production


```shell
git push origin main
```

Troubleshooting : See CICD Workflow in [Actions](https://github.com/benoit-marechal/benoit-marechal.github.io/actions) section.


Wait 10 min and see result : https://benoit-marechal.github.io


### Updating dependecies

Sometimes update dependecies of the *Gemfile* with this informations : 
https://pages.github.com/versions/



# DEV Environnement with CodeSpace


# DIT

```shell
cd ~/Projets/benoit-marechal.github.io
jekyll new --force .
```


## Test excution 

```shell
bundle exec jekyll serve
```

