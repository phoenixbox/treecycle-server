require 'securerandom'

module ErrorSerializer
  def ErrorSerializer.serialize(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash.map do |key, message|
      meta = {}
      meta[key] = message.join(' ')

      {
        id: SecureRandom.uuid,
        title: key.to_s + ' ' + message[0] + ".",
        meta: meta
      }
    end.flatten
    # set the json root and return
    json[:errors] = new_hash
    json
   end
 end
=begin
  JSON API spec errors
  var jsonFormat =
 {
   "errors": [
     {
       "id": "name",
       status: 400,
       code: '',
       detail: ''' ,
       title: '',
       meta: {}
     } // ...
   ]
 }
=end
