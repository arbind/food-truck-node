geocoder = require 'geocoder'

class GeocodeService
  @geoCoordinates: (place, callback)->
    geocoder.geocode place, (err, data)->
      location = data?.results?[0]?.geometry?.location
      lat = location?.lat
      lng = location?.lng
      callback err, { lat, lng }

  @geoAddress: ({lat, lng}, callback)->
    geocoder.reverseGeocode lat, lng, (err, data)->
      address =
        display: data?.results?[0]?.formatted_address
        number: 0
        street: null
        city: null
        state: null
        zip: null
        country: null
      callback err, { lat, lng }

module.exports = GeocodeService