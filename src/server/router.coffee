module.exports = (app) ->

  app.get '/sitemap.xml', (req, res) ->
    res.sendfile 'sitemap.xml', {
      root: app.static
    }

  app.get '/robots.txt', (req, res) ->
    res.sendfile 'robots.txt', {
      root: app.static
    }

  app.get "*", (req, res) ->
    res.render 'index.ect', {
      url: req.url
    }
