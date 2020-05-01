
# coding: utf-8

# In[ ]:


x = 'coffee'
y = 'HOUR'


# In[ ]:


#string slicing

z= x[2:]
print(z)


# In[ ]:


#string length
len(z)


# In[ ]:


x.upper()


# In[ ]:


x.capitalize()


# In[ ]:


y.lower()


# In[ ]:


z = 'pizza 4 u'
z.replace('4 u', y)


# In[ ]:


date = '04/10/2020'
month, day, year = date.split('/')
print(month, day, year)


# In[ ]:


'-'.join([day, month, year])


# In[ ]:


x + ' ' + y #concatenate


# In[ ]:


#Adding new info using .format(info1,info2)
#we want to print: "Earth is the 3rd planet in solar system."

planet = 'Earth'
position = 3

#Clumsy way
planet + " is the " + str(position) + "rd planet in solar system."

#Clean way
#"{} is the {}rd planet in solar system.".format(planet,position)

