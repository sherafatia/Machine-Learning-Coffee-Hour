
# coding: utf-8

# In[ ]:


month_dict = {'January': 1, 'February':2, 'March':3, 'April':4 }


# In[ ]:


#Finding the value of a key
month_dict['April']


# In[ ]:


#set of keys
month_dict.keys()


# In[ ]:


#set of values
month_dict.values()


# In[ ]:


#delete key:value pair
del month_dict['April']


# In[ ]:


month_dict


# In[ ]:


#Add new key_value pair
month_dict['May'] = 5
month_dict


# In[ ]:


#Change value for a key
month_dict['March'] ='Spring'
month_dict


# In[ ]:


#Check if a key:value exists

'June' in month_dict
#'February' in month_dict


# In[ ]:


#looping 

for i in month_dict:
    print("{}:{}".format(i, month_dict[i]))

