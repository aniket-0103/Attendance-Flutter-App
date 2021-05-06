from flask import Flask, jsonify, request
import json
import cv2
import face_recognition

#declared an empty variable for reassignment
response = ''

#creating the instance of our flask application
app = Flask(__name__)
d={}

#route to entertain our post and get request from flutter app
@app.route('/name', methods = ['GET', 'POST'])
def nameRoute():

    #fetching the global response variable to manipulate inside the function
    global response

    if request.method == 'POST':
        uploaded_file = request.files['image']
        if uploaded_file.filename != '':
            uploaded_file.save("ABB.jpeg")
        # SATRT
        elon = face_recognition.load_image_file('Kuldeep.jpeg')
        elon = cv2.cvtColor(elon, cv2.COLOR_BGR2RGB)
        elencod = face_recognition.face_encodings(elon)[0]

        # for billgates
        bill = face_recognition.load_image_file('billgates.jpg')
        bill = cv2.cvtColor(bill, cv2.COLOR_BGR2RGB)
        billencode = face_recognition.face_encodings(bill)[0]
        # for warrenbuffe
        warren = face_recognition.load_image_file('Nishant.jpeg')
        warren = cv2.cvtColor(warren, cv2.COLOR_BGR2RGB)
        warrenencode = face_recognition.face_encodings(warren)[0]
        # for the test image
        # for test imag
        test = face_recognition.load_image_file('ABB.jpeg')
        test = cv2.cvtColor(test, cv2.COLOR_BGR2RGB)
        testencode = face_recognition.face_encodings(test)[0]
        results = face_recognition.compare_faces([elencod], testencode)[0]
        if (face_recognition.compare_faces([elencod], testencode)[0]):
            print('kuldeep')
            d['name']='kuldeep'
        elif (face_recognition.compare_faces([billencode], testencode)[0]):
            print("bill")
            d['name'] = 'bill'

        elif (face_recognition.compare_faces([warrenencode], testencode)[0]):
            print("warren")
            d['name'] = 'warren'
        else:
            print("unknown")
        # END
        return ''
        #" #jsonify({'name' : "recieved succesfully"}) #sending data back to your frontend app

@app.route('/hello', methods=['GET'])
def helloWorld():
        print("hello")
        if request.method == "GET":
            return jsonify(d)

    #checking the request type we get from the app
    #if(request.method == 'POST'):
     #   print(request)
      #  request_data = request.files.get('image','')#.get('imagefile','') #getting the response data
        #request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
       # print("recieved image")
        #name = request_data['name'] #assigning it to name
        #print(type(request_data))
        #print(request_data)
        #cv2.imwrite(r"/hello.jpg",request_data)
        #response = f'Hi {name}! this is Python' #re-assigning response with the name we got from the user
        #return " " #to avoid a type error
    #else:
     #   return " " #jsonify({'name' : response}) #sending data back to your frontend app

if __name__ == "__main__":
    app.run(debug=True)