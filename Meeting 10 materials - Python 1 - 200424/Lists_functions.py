
# coding: utf-8

# In[ ]:


planets = ['Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter']


# In[ ]:


#Slicing
#planets[1:3]
planets[-2:]
#planets[1:-2]


# In[ ]:


#Replacing item in lists
planets[3]='Pluto'
planets


# In[ ]:


# Alphabetical ordering
sorted(planets) 


# In[ ]:


#Adding items
planets.append('Uranus')
print(planets)


# In[ ]:


#removes last element
planets.pop() 
print(planets)


# In[ ]:


#Finding index of item
planets.index('Pluto')


# In[ ]:


#for loops

for planet in planets:
   # print(planet, '&')
    print(planet, end = ',') #in same line

for i in planets:
    print(i)
   


# In[ ]:


#range

for i in range(5):
    print(i)


# In[ ]:


hands = [['j', 'k','l'], ['m', 'n', 'o'], ['p', 'q', 'r']]
#hands[0]
#hands[-1]
hands[1][0]

