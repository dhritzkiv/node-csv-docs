# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig =

  # Template Data
  # =============
  # These are variables that will be accessible via our templates
  # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

  templateData:

    # Specify some site properties
    site:
      # The production url of our website
      url: "http://csv.adaltas.com"

      # Here are some old site urls that you would like to redirect from
      oldUrls: [
        'adaltas.com/projects/node-csv'
      ]

      # The default title of our website
      title: "Node.js CSV project"

      # The website description (for SEO)
      description: """
        CSV parser and stringifier with a simple api, full of options and tested against large datasets.
        """

      # The website keywords (for SEO) separated by commas
      keywords: """
        csv, parser, stringifier, nodejs
        """

      # The website author's name
      author: "David Worms"

      # The website author's email
      email: "david@adaltas.com"

      # Your company's name
      copyright: "© Adaltas 2014"
      
      sitemap:
        '/csv':
          label: 'CSV'
          children:
            '/':
              label: 'Homepage'
            '/csv':
              label: 'Documentation'
            '/csv/examples':
              label: 'Examples'
            '/csv/community':
              label: 'Community'
            'https://github.com/wdavidw/node-csv':
              label: 'GitHub'
            'https://github.com/wdavidw/node-csv/blob/master/src/index.coffee.md':
              label: 'Source Code'
            'https://www.npmjs.org/package/csv':
              label: 'NPM'
        '/generate':
          label: 'Generate'
          children:
            '/generate':
              label: 'Documentation'
            '/generate/examples':
              label: 'Examples'
            'https://github.com/wdavidw/node-csv-generate':
              label: 'GitHub'
            'https://github.com/wdavidw/node-csv-generate/blob/master/src/index.coffee.md':
              label: 'Source Code'
            'https://www.npmjs.org/package/stream-generate':
              label: 'NPM'
        '/parse':
          label: 'Parse'
          children:
            '/parse':
              label: 'Documentation'
            '/parse/examples':
              label: 'Examples'
            'https://github.com/wdavidw/node-csv-parse':
              label: 'GitHub'
            'https://github.com/wdavidw/node-csv-parse/blob/master/src/index.coffee.md':
              label: 'Source Code'
            'https://www.npmjs.org/package/csv-parse':
              label: 'NPM'
        '/transform':
          label: 'Transform'
          children:
            '/transform':
              label: 'Documentation'
            '/transform/examples':
              label: 'Examples'
            'https://github.com/wdavidw/node-stream-transform':
              label: 'GitHub'
            'https://github.com/wdavidw/node-stream-transform/blob/master/src/index.coffee.md':
              label: 'Source Code'
            'https://www.npmjs.org/package/csv-transform':
              label: 'NPM'
        '/stringify':
          label: 'Stringify'
          children:
            '/stringify':
              label: 'Documentation'
            '/stringify/examples':
              label: 'Examples'
            'https://github.com/wdavidw/node-csv-stringify':
              label: 'GitHub'
            'https://github.com/wdavidw/node-csv-stringify/blob/master/src/index.coffee.md':
              label: 'Source Code'
            'https://www.npmjs.org/package/csv-stringify':
              label: 'NPM'
        '/legacy':
          label: 'Legacy'
          children:
            '/legacy':
              label: 'Introduction'
            '/legacy/from':
              label: 'Reading data from a source'
            '/legacy/to':
              label: 'Writing data to a destination'
            '/legacy/transformer':
              label: 'Transforming data'
            '/legacy/columns':
              label: 'Columns'
            '/legacy/parser':
              label: 'Parsing'
            '/legacy/stringifier':
              label: 'Stringifier'
            '/legacy/changes':
              label: 'Changes in latest versions'


    # Helper Functions
    # ----------------

    # Get the prepared site/document title
    # Often we would like to specify particular formatting to our page's title
    # we can apply that formatting here
    getPreparedTitle: ->
      # if we have a document title, then we should use that and suffix the site's title onto it
      if @document.title
        "#{@document.title} | #{@site.title}"
      # if our document does not have it's own title, then we should just use the site's title
      else
        @site.title

    # Get the prepared site/document description
    getPreparedDescription: ->
      # if we have a document description, then we should use that, otherwise use the site's description
      @document.description or @site.description

    # Get the prepared site/document keywords
    getPreparedKeywords: ->
      # Merge the document keywords with the site keywords
      @site.keywords.concat(@document.keywords or []).join(', ')


  # Collections
  # ===========
  # These are special collections that our website makes available to us

  collections:
    # For instance, this one will fetch in all documents that have pageOrder set within their meta data
    pages: (database) ->
      database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

    # This one, will fetch in all documents that will be outputted to the posts directory
    posts: (database) ->
      database.findAllLive({relativeOutDirPath:'posts'},[date:-1])


  # DocPad Events
  # =============

  # Here we can define handlers for events that DocPad fires
  # You can find a full listing of events on the DocPad Wiki
  events:

    # Server Extend
    # Used to add our own custom routes to the server before the docpad routes are added
    serverExtend: (opts) ->
      # Extract the server from the options
      {server} = opts
      docpad = @docpad

      # As we are now running in an event,
      # ensure we are using the latest copy of the docpad configuraiton
      # and fetch our urls from it
      latestConfig = docpad.getConfig()
      oldUrls = latestConfig.templateData.site.oldUrls or []
      newUrl = latestConfig.templateData.site.url

      # Redirect any requests accessing one of our sites oldUrls to the new site url
      server.use (req,res,next) ->
        if req.headers.host in oldUrls
          res.redirect 301, newUrl+req.url
        else
          next()


# Export our DocPad Configuration
module.exports = docpadConfig


