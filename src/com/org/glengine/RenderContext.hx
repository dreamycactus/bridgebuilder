package com.org.glengine;

#if cpp
typedef RenderContext = BrEngine;
#else
typedef RenderContext = EmptyEngine;
#end
