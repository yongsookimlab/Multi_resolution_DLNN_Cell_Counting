# import the necessary packages
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers, models
from tensorflow.keras.layers import Dense, Conv2D, Flatten, Dropout, MaxPooling2D, concatenate
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import numpy as np
import h5py

with h5py.File("../003_Preparing_training/0031brain.h5", "r") as f:
    print("Keys: %s" % f.keys())
    ans_train = f['ans_train'][()]
    ans_validate = f['ans_validate'][()]
    image1 = f['image1'][()]
    image2 = f['image2'][()]
    image3 = f['image3'][()]
    validate1 = f['validate1'][()]
    validate2 = f['validate2'][()]
    validate3 = f['validate3'][()]


def res_net_block(input_data, filters, conv_size):
  x = layers.Conv2D(filters, conv_size, activation='relu', padding='same')(input_data)
  x = layers.BatchNormalization()(x)
  x = layers.Conv2D(filters, conv_size, activation=None, padding='same')(x)
  x = layers.BatchNormalization()(x)
  x = layers.Add()([x, input_data])
  x = layers.Activation('relu')(x)
  return x



num_res_net_blocks = 3
percent_dropoff = 0.25
num_cnn_depth_l_1 = 16
num_cnn_depth_l_2 = 32
num_cnn_depth_l_3 = 32

final_depth = 128
flat_depth = 128







"""
import numpy as np

ans_train[:,0] = [0 if ele == 1 else ele for ele in ans_train ]
ans_validate[:,0] = [0 if ele == 1 else ele for ele in ans_validate ]

ans_train[:,0] = [1 if ele == 2 else ele for ele in ans_train ]
ans_validate[:,0] = [1 if ele == 2 else ele for ele in ans_validate ]

ans_train[:,0] = [1 if ele == 3 else ele for ele in ans_train ]
ans_validate[:,0] = [1 if ele == 3 else ele for ele in ans_validate ]

ans_train[:,0] = [1 if ele == 4 else ele for ele in ans_train ]
ans_validate[:,0] = [1 if ele == 4 else ele for ele in ans_validate ]

"""

ans_train = np.int_(ans_train)
ans_validate = np.int_(ans_validate)


image1 = np.float32(image1)
image2 = np.float32(image2)
image3 = np.float32(image3)
#image4 = np.float32(image4)
validate1 = np.float32(validate1)
validate2 = np.float32(validate2)
validate3 = np.float32(validate3)
#validate4 = np.float32(validate4)





#mirrored_strategy = tf.distribute.MirroredStrategy(cross_device_ops=tf.distribute.HierarchicalCopyAllReduce())
#with mirrored_strategy.scope():


inputs_1 = keras.Input(shape=(101, 101, 2))
inputs_2 = keras.Input(shape=(201, 201, 2))
inputs_3 = keras.Input(shape=(201, 201, 2))
#inputs_4 = keras.Input(shape=(101, 101, 2))




x = layers.Conv2D(num_cnn_depth_l_1, 7, activation='relu')(inputs_1)
x = layers.Conv2D(num_cnn_depth_l_1, 3, activation='relu')(x)
x = layers.MaxPooling2D(3)(x)
for i in range(num_res_net_blocks):
    x = res_net_block(x, num_cnn_depth_l_1, 3)
x = layers.Dropout(percent_dropoff)(x)
x = layers.Conv2D(num_cnn_depth_l_2, 3, activation='relu')(x)
x = layers.MaxPooling2D(3)(x)
for i in range(num_res_net_blocks):
    x = res_net_block(x, num_cnn_depth_l_2, 3)
x = layers.Dropout(percent_dropoff)(x)    
x = layers.GlobalAveragePooling2D()(x)
#x = layers.Flatten()(x)
x = layers.Dense(num_cnn_depth_l_3, activation='relu')(x)

    
y = layers.Conv2D(num_cnn_depth_l_1, 7, activation='relu')(inputs_2)
y = layers.Conv2D(num_cnn_depth_l_1, 3, activation='relu')(y)
y = layers.MaxPooling2D(3)(y)
for i in range(num_res_net_blocks):
    y = res_net_block(y, num_cnn_depth_l_1, 3)
y = layers.Dropout(percent_dropoff)(y)
y = layers.Conv2D(num_cnn_depth_l_2, 3, activation='relu')(y)
y = layers.MaxPooling2D(3)(y)
for i in range(num_res_net_blocks):
    y = res_net_block(y, num_cnn_depth_l_2, 3)
y = layers.Dropout(percent_dropoff)(y)
y = layers.Conv2D(num_cnn_depth_l_3, 3, activation='relu')(y)
y = layers.MaxPooling2D(3)(y)
for i in range(num_res_net_blocks):
    y = res_net_block(y, num_cnn_depth_l_3, 3)
y = layers.Dropout(percent_dropoff)(y)    
y = layers.GlobalAveragePooling2D()(y)
#y = layers.Flatten()(y)
y = layers.Dense(final_depth, activation='relu')(y)
    

z = layers.Conv2D(num_cnn_depth_l_1, 7, activation='relu')(inputs_3)
z = layers.Conv2D(num_cnn_depth_l_1, 3, activation='relu')(z)
z = layers.MaxPooling2D(3)(z)
for i in range(num_res_net_blocks):
    z = res_net_block(z, num_cnn_depth_l_1, 3)
z = layers.Dropout(percent_dropoff)(z)
z = layers.Conv2D(num_cnn_depth_l_2, 3, activation='relu')(z)
z = layers.MaxPooling2D(3)(z)
for i in range(num_res_net_blocks):
    z = res_net_block(z, num_cnn_depth_l_2, 3)
z = layers.Dropout(percent_dropoff)(z)
z = layers.Conv2D(num_cnn_depth_l_3, 3, activation='relu')(z)
z = layers.MaxPooling2D(3)(z)
for i in range(num_res_net_blocks):
    z = res_net_block(z, num_cnn_depth_l_3, 3)
z = layers.Dropout(percent_dropoff)(z)
z = layers.GlobalAveragePooling2D()(z)
#z = layers.Flatten()(z)
z = layers.Dense(final_depth, activation='relu')(z)

"""
a = layers.Conv2D(num_cnn_depth_l_1, 7, activation='relu')(inputs_4)
a = layers.Conv2D(num_cnn_depth_l_1, 3, activation='relu')(a)
a = layers.MaxPooling2D(3)(a)
for i in range(num_res_net_blocks):
    a = res_net_block(a, num_cnn_depth_l_1, 3)
a = layers.Dropout(percent_dropoff)(a)
a = layers.Conv2D(num_cnn_depth_l_2, 3, activation='relu')(a)
a = layers.MaxPooling2D(3)(a)
for i in range(num_res_net_blocks):
    a = res_net_block(a, num_cnn_depth_l_2, 3)
a = layers.Dropout(percent_dropoff)(a)    
a = layers.GlobalAveragePooling2D()(a)
a = layers.Dense(final_depth, activation='relu')(a)
"""


#combinedInput = concatenate([x, y, z, a])
combinedInput = concatenate([x,y, z])

w = Dense(flat_depth, activation="relu")(combinedInput)
w = Dense(3, activation="softmax")(w)


#model = keras.Model(inputs=[inputs_1, inputs_2, inputs_3, inputs_4], outputs=w)
model = keras.Model(inputs=[inputs_1, inputs_2,inputs_3], outputs=w)
model.compile(loss="sparse_categorical_crossentropy", optimizer=tf.keras.optimizers.Adam(), metrics=['accuracy'])

model.summary()



model.fit(
	#[image1, image2, image3, image4], ans_train, 
	#validation_data=([validate1, validate2, validate3, validate4], ans_validate),
    [image1, image2,image3], ans_train, 
    validation_data=([validate1, validate2,validate3], ans_validate),
    batch_size=16,
	epochs=50)


model.fit(
	#[image1, image2, image3, image4], ans_train, 
	#validation_data=([validate1, validate2, validate3, validate4], ans_validate),
    [image1, image2,image3], ans_train, 
    validation_data=([validate1, validate2,validate3], ans_validate),
    batch_size=32,
	epochs=50)


model.fit(
	#[image1, image2, image3, image4], ans_train, 
	#validation_data=([validate1, validate2, validate3, validate4], ans_validate),
    [image1, image2,image3], ans_train, 
    validation_data=([validate1, validate2,validate3], ans_validate),
    batch_size=64,
	epochs=10)
"""
model.fit(
	#[image1, image2, image3, image4], ans_train, 
	#validation_data=([validate1, validate2, validate3, validate4], ans_validate),
    [image1, image2,image3], ans_train, 
    validation_data=([validate1, validate2,validate3], ans_validate),
    batch_size=128,
	epochs=5)
"""
#predictions_b = model.predict([validate1, validate2, validate3, validate4])
#predictions_b_max = np.argmax(predictions_b, axis=1)


model.save('p.h5')

 