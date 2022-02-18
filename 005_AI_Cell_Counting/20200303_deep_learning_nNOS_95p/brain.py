import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, models
from tensorflow.keras.layers import Dense, Conv2D, Flatten, Dropout, MaxPooling2D
import numpy as np
import h5py

#config = tf.compat.v1.ConfigProto(gpu_options = 
#                         tf.compat.v1.GPUOptions(per_process_gpu_memory_fraction=0.8)
# device_count = {'GPU': 1}
#)
#config.gpu_options.allow_growth = True
#session = tf.compat.v1.Session(config=config)
#tf.compat.v1.keras.backend.set_session(session)


filename = 'current_slice.h5'
hf = h5py.File(filename, 'r')
aa = list(hf.keys())
image1 = hf.get('image1')
image1 = np.array(image1)
image2 = hf.get('image2')
image2 = np.array(image2)
image3 = hf.get('image3')
image3 = np.array(image3)
image4 = hf.get('image4')
image4 = np.array(image4)
image1_loc = hf.get('image1_loc')
image1_loc = np.array(image1_loc)
hf.close()


model = tf.keras.models.load_model('95p.h5')

predictions_b = model.predict([image1, image2, image3])

predictions_max = np.argmax(predictions_b, axis=1)


hf = h5py.File('data_back.h5', 'w')
hf.create_dataset('predictions_max', data=predictions_max)
hf.create_dataset('image1_loc', data=image1_loc)
hf.close()
