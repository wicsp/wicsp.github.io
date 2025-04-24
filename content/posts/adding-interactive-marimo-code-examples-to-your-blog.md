+++
date = '2025-04-21T09:59:26+08:00'
title = 'Adding Interactive Marimo Code Examples to Your Blog'
+++



## marimo-snippets

{{< github repo="marimo-team/marimo-snippets" >}}


## Initialize marimo snippets

Include the following to load marimo snippets on your web page:

```html
<script src="https://cdn.jsdelivr.net/npm/@marimo-team/marimo-snippets@1"></script>
```

<script src="https://cdn.jsdelivr.net/npm/@marimo-team/marimo-snippets@1"></script>

## Linking to notebooks

Use `<marimo-button>` to link out to a notebook:

````html
<div>
<marimo-button>
<!-- Add a blank line here, or it may cause some problems -->

```python
def hello_world():
    print("Hello, World!")

hello_world()
```
</marimo-button>
</div>
````

renders as

<div>
<marimo-button>

```python
def hello_world():
    print("Hello, World!")

hello_world()
```
</marimo-button>
</div>

## Embedding notebooks inline

It's also possible to replace a code block with an inlined notebook, using `<marimo-iframe>`:

````html
<div>
<marimo-iframe>

```python
def hello_world():
    print("Hello, World!")

hello_world()
```
</marimo-iframe>
</div>
````

<div>
<marimo-iframe>

```python
def hello_world():
    print("Hello, World!")

hello_world()
```
</marimo-iframe>
</div>


Multiple code blocks will be replaced with an entire notebook:

````html
<div>
<marimo-iframe data-height="600px">

```python
import marimo as mo
```

```python
slider = mo.ui.slider(1, 10)
slider
```

```python
slider.value * "🍃"
```
</marimo-iframe>
</div>
````

renders as

<div>
<marimo-iframe data-height="600px">

```python
import marimo as mo
```

```python
slider = mo.ui.slider(1, 10)
slider
```

```python
slider.value * "🍃"
```
</marimo-iframe>
</div>

