import math
import numpy as np


A_sign_long_list = []
W_sign_long_list = []
A_val_long_list = []
W_val_long_list = []

A_sign_short_list = []
A_val_short_list = []
W_sign_short_list = []
W_val_short_list = []

bin =[0, 0, 0, 0]


def fill_short_vector_binary(sign_short_list, val_short_list, value_A_W):

    sign_short_list.clear();
    val_short_list.clear();

    for i in range(7):
        if (value_A_W & 1):
            sign_short_list.append(1)
            val_short_list.append(i)
        
        value_A_W = value_A_W >> 1;
   

    if (value_A_W & 1):
        sign_short_list.append(-1)
        val_short_list.append(7)
    

    #print(sign_short_list);
    #print(val_short_list);

def fill_short_vector_booth(sign_short_list, val_short_list, value_A_W): 

    sign_short_list.clear()
    val_short_list.clear()

    set = [0, 0, 0, 0]

    set[0] = (value_A_W & 0x3) << 1
    set[1] = (value_A_W >> 1) & 0x7
    set[2] = (value_A_W >> 3) & 0x7
    set[3] = (value_A_W >> 5) & 0x7

    for i in range(4):
        if (booth_lut(set[i]) != 0):
            termsA = booth_lut(set[i]) * pow(2, 2 * i)
            termsA = int(math.log(abs(termsA), 2))
            
            if (booth_lut(set[i]) > 0):
                sign_short_list.append(1)
            else:
                sign_short_list.append(-1)
            
            val_short_list.append(termsA)

            #sign_short_list.append(if(booth_lut(set[i]) > 0 else 1 : -1))
            
        
    #print(sign_short_list)
    #print(val_short_list)


def test_array_result():
    
    s_test_size = len(A_sign_long_list)
    accu = 0

    
    
    
    for i in range(s_test_size):
        exp_res = A_val_long_list[i] + W_val_long_list[i]
        sign_res = A_sign_long_list[i] * W_sign_long_list[i]

        accu += sign_res * pow(2, exp_res);
    

    return accu;
    


def laconic_simulator_result():
    
    # laconic-simulator -------------------
    
    s_test_size = len(A_sign_long_list)
   #print("width =", s_test_size)
    accu23 = 0
    
    #word_length = 100

    itersteps = math.ceil(s_test_size / 16.0)
   #print(itersteps)
    laststep_len = (s_test_size % 16)
   #print(laststep_len)
   #print("---")

    for iter_inst in range(itersteps):

        start_index = 16*iter_inst
        end_index = min(16*iter_inst + 15, s_test_size-1)
       #print("---")
       #print(start_index, ":", end_index)
       #print("---")
    
    

        exp_add = np.zeros(16).astype(int)
        exp_sign = np.zeros(16).astype(int)

        decoder_array = np.zeros((16, 15)).astype(int)
        
        #print(decoder_array)


        for i_x1 in range(start_index, end_index + 1):
            exp_res = A_val_long_list[i_x1] + W_val_long_list[i_x1]
            exp_add[i_x1%16] = exp_res
            sign_res = A_sign_long_list[i_x1] * W_sign_long_list[i_x1]
            exp_sign[i_x1%16] = sign_res

        for i_x2 in range(start_index, end_index + 1):
            decoder_array[i_x2%16][int(exp_add[i_x2%16])] = 1


       #print("---")
       #print(decoder_array)
       #print("---")
       #print(exp_sign)
       #print("---")
        hist_input = np.zeros((16, 15)).astype(int)
        hist_input = decoder_array * exp_sign[:, np.newaxis]
        #print(hist_input)

        #decoder_out = decoder_array.sum(axis=0)
        #print(decoder_out)
       #print("---")
       #print("hist_input_pos")
        hist_input_pos = np.maximum(hist_input, 0)
       #print(hist_input_pos)

       #print("---")
       #print("hist_input_neg")
        hist_input_neg = np.minimum(hist_input, 0)
        hist_input_neg[hist_input < 0] = 1
       #print(hist_input_neg)


        histogram_out_pos = np.zeros(15)
        histogram_out_pos = histogram_out_pos.astype(int)
        histogram_out_neg = np.zeros(15)
        histogram_out_neg = histogram_out_neg.astype(int)
       #print("---")

        for r in range(15):

            pos_vec = hist_input_pos[:, r]
            histogram_out_pos[r] = GPC_count(pos_vec)
            #print("histogram_out_pos[",  r, "] :", histogram_out_pos[r])

       #print("---")

        for r in range(15):
            neg_vec = hist_input_neg[:, r]
            histogram_out_neg[r] = GPC_count(neg_vec)
            #print("histogram_out_neg[",  r, "] :", histogram_out_neg[r])


        GPC_out = np.zeros(16).astype(int)
        GPC_out = histogram_out_pos - histogram_out_neg

       #print("GPC_out", GPC_out)

        alignment_result = np.zeros(16).astype(int)

        for r in range(15):
            alignment_result[r] = GPC_out[r] << r
           #print("alignment_result[", r, "] =", alignment_result[r])


       #print("---")
        mac_res = np.sum(alignment_result)
       #print("MAC result = ", np.sum(alignment_result))

        #print("pos Hist")
        #print(histogram_out_pos)
        #print("neg Hist")
        #print(histogram_out_pos)
        #print(exp_sign)
       #print("---")
        #print(np.multiply(exp_sign, histogram_out))

        accu23 += mac_res
        #print("accu23 =", accu23)
        
   #print("MAC result = ", accu23)
    return accu23

        # laconic-simulator end -------------------


    
    
def booth_lut(in_val): 
    
    if (in_val == 0):
        return 0
    elif (in_val == 1):
        return 1
    elif (in_val == 2):
        return 1     
    elif (in_val == 3): 
        return 2      
    elif (in_val == 4):  
        return -2     
    elif (in_val == 5):  
        return -1 
    elif (in_val == 6):  
        return -1 
    else:
        return 0 

def encode_len_binary(A):
    termsA = 0

    for i_x in range(8):
        if (A & 0x1):
            termsA += 1

        A = A >> 1

    return termsA

def encode_len_booth(value_A_W):

    termsA = 0;

    set = [0, 0, 0, 0]

    set[0] = (value_A_W & 0x3) << 1;
    set[1] = (value_A_W >> 1) & 0x7;
    set[2] = (value_A_W >> 3) & 0x7;
    set[3] = (value_A_W >> 5) & 0x7;

    
    for i_x in range(4):
        if (booth_lut(set[i_x]) != 0):
            termsA += 1;

    return termsA;

def min_lane(A, W):

    A_binary = 0 
    A_booth = 0
    W_binary = 0
    W_booth = 0

    A_binary = encode_len_binary(A);
    A_booth = encode_len_booth(A);
    W_binary = encode_len_binary(W);
    W_booth = encode_len_booth(W);

    min_comb = [0, 0, 0, 0]

    min_comb[0] = A_binary * W_binary;
    min_comb[1] = A_binary * W_booth;
    min_comb[2] = A_booth * W_binary;
    min_comb[3] = A_booth * W_booth;


    min_index = min_comb.index(min(min_comb))
    #bin[min_index] += 1

    return(min_index)

def min_len_populate(A_in, W_in):

    path_to_take = min_lane(A_in, W_in)

    if (path_to_take == 0):
        fill_short_vector_binary(A_sign_short_list, A_val_short_list, A_in)
        fill_short_vector_binary(W_sign_short_list, W_val_short_list, W_in)
    elif (path_to_take == 1):
        fill_short_vector_binary(A_sign_short_list, A_val_short_list, A_in)
        fill_short_vector_booth(W_sign_short_list, W_val_short_list, W_in)
    elif (path_to_take == 2):
        fill_short_vector_booth(A_sign_short_list, A_val_short_list, A_in)
        fill_short_vector_binary(W_sign_short_list, W_val_short_list, W_in)
    else:
        fill_short_vector_booth(A_sign_short_list, A_val_short_list, A_in)
        fill_short_vector_booth(W_sign_short_list, W_val_short_list, W_in)

    w_len = len(W_sign_short_list)
    a_len = len(A_sign_short_list)

    for w_run in range(w_len):
        for a_run in range(a_len):

            W_sign_long_list.append(W_sign_short_list[w_run])
            W_val_long_list.append(W_val_short_list[w_run])

            A_sign_long_list.append(A_sign_short_list[a_run])
            A_val_long_list.append(A_val_short_list[a_run])

    

# ---------------------------------------------------
def input_A_W(A_subset, W_subset):
    
    A_subset_inst = np.array(A_subset).astype(np.int8).flatten()
    W_subset_inst = np.array(W_subset).astype(np.int8).flatten()
    
    A_sign_long_list.clear()
    W_sign_long_list.clear()
    A_val_long_list.clear()
    W_val_long_list.clear()


   #print("A_subset_inst :", A_subset_inst)
   #print("W_subset_inst :", W_subset_inst)

    for i in range(len(A_subset_inst)):
        min_len_populate(A_subset_inst[i], W_subset_inst[i])
        #print(min_lane(A_subset_inst[i], W_subset_inst[i]))
        #print("----")




   #print("A_sign_long_list :\t", A_sign_long_list)
   #print("A_val_long_list :\t", A_val_long_list)
   #print("W_sign_long_list :\t", W_sign_long_list)
   #print("W_val_long_list :\t", W_val_long_list)

    #print(A_subset_inst)
    #print(W_subset_inst)
    

    #print(type(A_subset_inst[0]))


def GPC_count(inp_vec):

    #global gpc_occurence11
    #global gpc_total_occurence
    
    
    #exct_res = np.sum(inp_vec) #exact result

    approx_res = ((inp_vec[0] | inp_vec[1]) + 
                    (inp_vec[2] | inp_vec[3]) + 
                    (inp_vec[4] | inp_vec[5]) + 
                    (inp_vec[6] | inp_vec[7]) + 
                    (inp_vec[8] | inp_vec[9]) + 
                    (inp_vec[10] | inp_vec[11] | inp_vec[12]) + 
                    (inp_vec[13] | inp_vec[14] | inp_vec[15]))
                    
    '''          
    gpc_total_occurence += 1
    if (exct_res != approx_res):
        gpc_occurence11 += 1
    '''
    return approx_res
    
	
    #return (inp_vec[0] + inp_vec[1] + inp_vec[2] + inp_vec[3] + inp_vec[4] + inp_vec[5] + inp_vec[6] + inp_vec[7] + inp_vec[8] + inp_vec[9] + inp_vec[10] + inp_vec[11] + inp_vec[12] + inp_vec[13] + inp_vec[14])
    

            

    #return np.sum(inp_vec)