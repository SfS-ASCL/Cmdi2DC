/** @jsx React.DOM */

var Container = React.createClass({
	getInitialState: function() {
		return {ok:true, msg:"", files: {}};
	},
	upload: function(event) {
		var that = this;
		var up = new Uploader("rest");
		up.onSuccess = function() {
			console.log("upload success", this);
			if (this.xhr.status === 200) {
				var json = JSON.parse(this.xhr.response);
				that.setState( {ok:true, msg:"", files: json});
			} else {
				that.setState( {ok:false, msg: this.xhr.response, files: {}});
			}
		};
		up.upload(event);
	},
	render: function() {
		var style = {marginTop:"20px"};
		return (
			<div className="container">
				<div className="row clearfix">
					<div className="col-md-12 column">
						<div className="jumbotron" style={style}>
							<h2>CMDI to Dublin Core transformer</h2>
							<p>This web service allows you to convert a CMDI metadata file to the Dublin Core format.</p> 
						</div>
						<FileUploadBox onUpload={this.upload}/>
						<StatusBox ok={this.state.ok} text={this.state.msg}/>
						<DownloadBox files={this.state.files}/>
					</div>
				</div>
			</div>
		);
	}
});

var FileUploadBox = React.createClass({
	propTypes: {
		onUpload: React.PropTypes.func.isRequired		
	},
	onUpload: function(event) {
		this.props.onUpload(event);
	},
	render: function() {
		var specialAddon = {marginRight:"10px", border:"none", background:"none"};
		return (
			<div className="fileUploadBox input-group">
				<span style={specialAddon}>
					Upload your CMDI files:
				</span>
				<span className="btn btn-default btn-file"> 
					Browse 
					<input type="file" name="fileUpload" onChange={this.onUpload}></input>
				</span>
			</div>
		);
	}
});

var StatusBox = React.createClass({
	propTypes: {
		ok: React.PropTypes.bool.isRequired,
		text:  React.PropTypes.string.isRequired
	},
	render: function() {
		var x;
		if (!this.props.ok)
			x = <div className="alert alert-danger" role="alert">{this.props.text}</div>;
		else if (this.props.text.length > 0)
			x = <div className="alert alert-success" role="alert">{this.props.text}</div>;
		return (<div className="statusBox"> {x} </div> );
	}
});

function iterateMap(map, fn) {
	var i = 0;
	for (var p in map) {
		if (map.hasOwnProperty(p)) {
			fn(i, p, map[p]);
		}
	}
}

var DownloadBox = React.createClass({
	propTypes: {
		files: React.PropTypes.object.isRequired
	},
	render: function() {
		var files = iterateMap(this.props.files, function (i, k, v) {
			return <li key={i} className="list-group-item"><a href={k}>{v}</a></li>;
		});
		var header = $.isEmptyObject(files) ? (<span></span>) : (<p>Download Dublin Core: </p>);
		return (<div> {header}
					<ul className="downloadBox list-group"> { files } </ul> 
				</div> );
	}
});

React.renderComponent(<Container/>, document.getElementById('main'));

///////////////////////////////////////////////////////////////////////////////

function Uploader(url) {
	var that = this;
	that.url = url;
	this.progress = -1;

	this.cancelUpload = function() {
		if (that.xhr)
			that.xhr.abort();
		that.xhr = null;
		that.progress = -1;
		if (that.onCancel)
			that.onCancel();
	};

	var onUploadProgress = function(e) {
		var done = e.position || e.loaded, total = e.totalSize || e.total;
		var percent = Math.floor( done / total * 1000 ) / 10;
		that.progress = percent;
	};

	this.upload = function(event) {
		var xhr = new XMLHttpRequest();
		xhr.addEventListener('progress', onUploadProgress, false);
		if ( xhr.upload ) {
			xhr.upload.onprogress = onUploadProgress;
		}
		xhr.onreadystatechange = function(e) {
			if ( 4 == e.currentTarget.readyState ) {
				that.progress = -1;
				if (that.onSuccess)
					that.onSuccess();
			}
		};

		xhr.open('post', that.url, true);
		var fd = new FormData();
		var finput = event.target;
		for (var i = 0; i < finput.files.length; ++i) {
			console.log('uploading file ', finput.files[i]);
			fd.append('file'+i, finput.files[i]);
		}
		xhr.send(fd);
		that.xhr = xhr;
	};
}
